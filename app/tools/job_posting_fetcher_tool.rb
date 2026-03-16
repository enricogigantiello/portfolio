require "net/http"
require "uri"

class JobPostingFetcherTool < RubyLLM::Tool
  description "Fetch a job posting URL and extract its text content so you can compare " \
              "its requirements against #{Profile.instance.full_name}'s portfolio. Use this when the user provides " \
              "a URL to a job listing or job description."

  param :url, desc: "The full URL of the job posting to fetch (must be http or https)"

  BLOCKED_PATTERNS = [
    /\Alocalhost\z/i,
    /\A127\.\d+\.\d+\.\d+\z/,
    /\A10\.\d+\.\d+\.\d+\z/,
    /\A172\.(1[6-9]|2\d|3[01])\.\d+\.\d+\z/,
    /\A192\.168\.\d+\.\d+\z/,
    /\A::1\z/,
    /\A0\.0\.0\.0\z/,
    /\Afd[0-9a-f]{2}:/i
  ].freeze

  MAX_REDIRECTS   = 5
  TIMEOUT_SECONDS = 10
  MAX_CHARS       = 4_000

  def execute(url:)
    uri = parse_and_validate(url)
    return { error: "Invalid or non-public URL. Only http/https URLs to public hosts are allowed." } unless uri

    text = fetch_text(uri, redirects_left: MAX_REDIRECTS)
    text.truncate(MAX_CHARS)
  rescue => e
    { error: "Could not fetch job posting: #{e.message}" }
  end

  private

  def parse_and_validate(raw_url)
    uri = URI.parse(raw_url.to_s.strip)
    return nil unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    return nil if blocked_host?(uri.host)

    uri
  rescue URI::InvalidURIError
    nil
  end

  def blocked_host?(host)
    return true if host.nil? || host.empty?

    BLOCKED_PATTERNS.any? { |pattern| host.match?(pattern) }
  end

  def fetch_text(uri, redirects_left:)
    raise "Too many redirects" if redirects_left.zero?

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl         = uri.is_a?(URI::HTTPS)
    http.open_timeout    = TIMEOUT_SECONDS
    http.read_timeout    = TIMEOUT_SECONDS

    request = Net::HTTP::Get.new(uri.request_uri)
    request["User-Agent"] = "Mozilla/5.0 (compatible; PortfolioAssistant/1.0)"
    request["Accept"]     = "text/html,application/xhtml+xml"

    response = http.request(request)

    case response
    when Net::HTTPSuccess
      parse_body(response.body)
    when Net::HTTPRedirection
      location = response["Location"]
      raise "Missing Location header on redirect" unless location

      new_uri = URI.parse(location)
      new_uri = uri + new_uri unless new_uri.absolute?
      raise "Redirect to blocked host" if blocked_host?(new_uri.host)

      fetch_text(new_uri, redirects_left: redirects_left - 1)
    else
      raise "HTTP #{response.code} #{response.message}"
    end
  end

  def parse_body(html)
    require "nokogiri"
    doc = Nokogiri::HTML(html)

    # Remove script/style/nav noise
    doc.css("script, style, nav, header, footer, iframe").remove

    doc.text.gsub(/[[:space:]]+/, " ").strip
  end
end
