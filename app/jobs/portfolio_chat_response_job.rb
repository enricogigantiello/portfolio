class PortfolioChatResponseJob < ApplicationJob
  def perform(chat_id, content, locale = I18n.default_locale.to_s)
    chat = Chat.find(chat_id)
    @profile = Profile.instance

    raise "Create a profile before using the chat" unless @profile

    # Set system prompt once — persisted as a system message in DB
    if chat.messages.where(role: :system).none?
      chat.with_instructions(system_prompt(locale))
    end

    chat
      .with_tool(PortfolioSearchTool)
      .with_tool(JobPostingFetcherTool)
      .ask(content) do |chunk|
        if chunk.content.present?
          message = chat.messages.last
          message.broadcast_append_chunk(chunk.content)
        end
      end

    # Re-render the completed assistant message so the link chips appear
    assistant_message = chat.messages.where(role: :assistant).last
    assistant_message&.broadcast_replace_message
  end

  private

  def system_prompt(locale)
    language_name = { "en" => "English", "it" => "Italian", "de" => "German" }.fetch(locale.to_s, "English")

    <<~PROMPT
      You are an AI assistant for #{@profile.full_name}'s professional portfolio website.
      Your job is to answer questions about his work experience, projects, technical skills, and education.

      ## How to respond
      - Always use the `portfolio_search` tool to retrieve relevant context before answering.
      - If the user provides a URL to a job posting, use the `job_posting_fetcher` tool to read it,
        then search the portfolio for matching skills and experiences.
      - When referencing a specific job, project, or education entry, include a markdown link
        using the URL paths listed in the index below. Format: [Label](URL)
      - Be concise, factual, and professional. Do not invent or infer experience not in the portfolio.
      - Respond in #{language_name}.

      ## Portfolio URL Index
      #{build_url_index}
    PROMPT
  end

  def build_url_index
    I18n.with_locale(:en) do
      lines = []

      Job.ordered.includes(:projects).each do |job|
        lines << "- [#{job.company} — #{job.role}](/en/jobs/#{job.id})"
        job.projects.ordered.each do |project|
          lines << "  - [#{project.title}](/en/jobs/#{job.id}/projects/#{project.id})"
        end
      end

      Education.ordered.each do |edu|
        lines << "- [#{edu.degree} at #{edu.institution}](/en/educations/#{edu.id})"
      end

      lines.join("\n")
    end
  end
end
