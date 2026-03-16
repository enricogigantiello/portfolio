class PortfolioSearchTool < RubyLLM::Tool
  description "Search #{Profile.instance.full_name}'s portfolio for relevant work experience, projects, " \
              "skills, or education. Use this for any question about his technical skills, " \
              "technologies used, work history, role types, or academic background."

  param :query, desc: "What to look for — e.g. 'React performance optimization', " \
                      "'team leadership', 'PostgreSQL', 'frontend architecture'"

  def execute(query:)
    docs = PortfolioDocument.search(query, limit: 5)
    return "No matching portfolio content found for: #{query}" if docs.empty?

    docs.map do |doc|
      url_part = doc.metadata["url"] ? " — #{doc.metadata['url']}" : ""
      "### #{doc.title}#{url_part}\n#{doc.content.truncate(500)}"
    end.join("\n\n")
  end
end
