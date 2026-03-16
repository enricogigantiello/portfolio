module MessagesHelper
  MARKDOWN_LINK_RE = /\[([^\]]+)\]\(([^)]+)\)/

  # Renders message content with markdown [label](url) converted to real links.
  def render_message_content(content)
    return "" if content.blank?

    result = ""
    last_end = 0

    content.scan(MARKDOWN_LINK_RE) do |label, url|
      match = Regexp.last_match
      result += html_escape(content[last_end...match.begin(0)])
      result += link_to(html_escape(label), url, target: "_blank", rel: "noopener")
      last_end = match.end(0)
    end

    result += html_escape(content[last_end..])
    content_tag(:span, result.html_safe, style: "white-space: pre-wrap;")
  end

  # Returns [[label, url], ...] for all internal portfolio links in the content.
  def extract_portfolio_links(content)
    return [] if content.blank?

    content.scan(MARKDOWN_LINK_RE)
           .select { |_label, url| url.match?(%r{\A/[a-z]{2}/}) }
           .uniq { |_label, url| url }
  end

  # Returns a Bootstrap icon class based on the URL path.
  def portfolio_link_icon(url)
    case url
    when %r{/jobs/\d+/projects/} then "bi-folder2-open"
    when %r{/jobs/}              then "bi-briefcase"
    when %r{/educations/}        then "bi-mortarboard"
    else                              "bi-link-45deg"
    end
  end
end
