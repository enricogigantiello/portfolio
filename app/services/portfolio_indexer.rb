class PortfolioIndexer
  def call
    I18n.with_locale(:en) do
      index_jobs
      index_educations
      index_languages
    end
  end

  def index_record(record)
    case record
    when Job       then I18n.with_locale(:en) { index_job(record) }
    when Project   then I18n.with_locale(:en) { index_project(record, record.job) }
    when Education then I18n.with_locale(:en) { index_education(record) }
    when Language  then I18n.with_locale(:en) { index_language(record) }
    end
  end

  private

  def index_jobs
    Job.ordered.includes(:projects, projects: [ :techs, :project_achievements ]).each do |job|
      index_job(job)
    end
  end

  def index_job(job)
    content = [
      "Company: #{job.company}",
      "Role: #{job.role}",
      ("Title: #{job.title}" if job.title.present?),
      "Period: #{format_date(job.start_date)} – #{format_date(job.end_date) || 'Present'}",
      job.description
    ].compact.join("\n")

    upsert_document(
      source: job,
      chunk_type: "job",
      title: "#{job.company} — #{job.role}",
      content: content,
      metadata: {
        "url"         => "/en/jobs/#{job.id}",
        "label"       => "#{job.company} — #{job.role}",
        "source_type" => "Job",
        "source_id"   => job.id
      }
    )

    job.projects.ordered.each { |project| index_project(project, job) }
  end

  def index_project(project, job)
    techs        = project.techs.pluck(:name).join(", ")
    achievements = project.project_achievements.order(:position).map { |a| "- #{a.description}" }.join("\n")

    content = [
      "Project: #{project.title}",
      "At: #{job.company}",
      ("Role: #{project.role}" if project.role.present?),
      ("Technologies: #{techs}" if techs.present?),
      project.description,
      ("Achievements:\n#{achievements}" if achievements.present?)
    ].compact.join("\n")

    upsert_document(
      source: project,
      chunk_type: "project",
      title: "#{project.title} at #{job.company}",
      content: content,
      metadata: {
        "url"         => "/en/jobs/#{job.id}/projects/#{project.id}",
        "label"       => "#{project.title} at #{job.company}",
        "source_type" => "Project",
        "source_id"   => project.id
      }
    )
  end

  def index_educations
    Education.ordered.each { |edu| index_education(edu) }
  end

  def index_education(edu)
    content = [
      "Degree: #{edu.degree}",
      "Institution: #{edu.institution}",
      "Period: #{format_date(edu.start_date)} – #{format_date(edu.end_date)}",
      edu.description
    ].compact.join("\n")

    upsert_document(
      source: edu,
      chunk_type: "education",
      title: "#{edu.degree} at #{edu.institution}",
      content: content,
      metadata: {
        "url"         => "/en/educations/#{edu.id}",
        "label"       => "#{edu.degree} at #{edu.institution}",
        "source_type" => "Education",
        "source_id"   => edu.id
      }
    )
  end

  def index_languages
    Language.ordered.each { |lang| index_language(lang) }
  end

  def index_language(lang)
    content = "Language: #{lang.name}, Level: #{lang.level.upcase} (#{lang.level_percentage}%)"

    upsert_document(
      source: lang,
      chunk_type: "language",
      title: "Language: #{lang.name}",
      content: content,
      metadata: {
        "source_type" => "Language",
        "source_id"   => lang.id
      }
    )
  end

  def upsert_document(source:, chunk_type:, title:, content:, metadata:)
    doc = PortfolioDocument.find_or_initialize_by(
      source_type: source.class.name,
      source_id:   source.id,
      chunk_type:  chunk_type
    )
    doc.assign_attributes(title: title, content: content, metadata: metadata)
    doc.save!
  end

  def format_date(date)
    date&.strftime("%b %Y")
  end
end
