ActiveAdmin.register ReferenceLink do
  config.filters = false

  permit_params :url, :link_type, :position,
                :label_en, :label_it, :label_de,
                :title, :description, :image, :favicon,
                :referenceable_type, :referenceable_id,
                thumbnail_data: {}

  index do
    selectable_column
    id_column
    column :label
    column :url do |link|
      link_to link.url, link.url, target: "_blank"
    end
    column :link_type do |link|
      status_tag link.link_type.humanize
    end
    column :referenceable do |link|
      if link.referenceable.is_a?(Project)
        link_to link.referenceable.title, admin_project_path(link.referenceable)
      elsif link.referenceable.is_a?(Job)
        link_to link.referenceable.company, admin_job_path(link.referenceable)
      end
    end
    column :position
    column :title
    column :description do |link|
      truncate(link.description, length: 100)
    end
    column :image
    column :favicon

    actions
  end

  show do
    attributes_table do
      row :label
      row :url do |link|
        link_to link.url, link.url, target: "_blank"
      end
      row :link_type do |link|
        status_tag link.link_type.humanize
      end
      row :referenceable do |link|
        if link.referenceable.is_a?(Project)
          link_to link.referenceable.title, admin_project_path(link.referenceable)
        elsif link.referenceable.is_a?(Job)
          link_to link.referenceable.company, admin_job_path(link.referenceable)
        end
      end
      row :position
      row :thumbnail_data do |link|
        link.thumbnail_data.present? ? content_tag(:pre, JSON.pretty_generate(link.thumbnail_data)) : "-"
      end
      row :title
      row :description
      row :image
      row :favicon
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs "Link Details" do
      # Create a combined collection with Job and Project options
      jobs_collection = Job.order(:company).map { |j| [ "[JOB] #{j.company}", "Job-#{j.id}", { data: { type: "Job", id: j.id } } ] }
      projects_collection = Project.order(:title).map { |p| [ "[PROJECT] #{p.title}", "Project-#{p.id}", { data: { type: "Project", id: p.id } } ] }
      combined_collection = jobs_collection + projects_collection

      current_value = if f.object.referenceable
        "#{f.object.referenceable_type}-#{f.object.referenceable_id}"
      end

      f.input :referenceable, as: :select,
              collection: combined_collection,
              input_html: { value: current_value },
              hint: "Select either a Job or a Project"
      f.input :url
      f.input :link_type, as: :select, collection: ReferenceLink.link_types.keys.map { |k| [ k.humanize, k ] }
      f.input :position
      f.input :title
      f.input :description
      f.input :image
      f.input :favicon
    end

    f.inputs "Thumbnail Data (JSON)" do
      f.input :thumbnail_data, as: :text, input_html: { value: f.object.thumbnail_data.present? ? JSON.pretty_generate(f.object.thumbnail_data) : "{}" }
    end

    I18n.available_locales.each do |locale|
      f.inputs "Translations (#{locale.to_s.upcase})" do
        f.input :label, as: :string, input_html: { name: "reference_link[label_#{locale}]", value: f.object.send("label_#{locale}") }, label: "Label"
      end
    end

    f.actions
  end

  controller do
    def update
      if params[:reference_link][:referenceable_id].present? && params[:reference_link][:referenceable_id].include?("-")
        type, id = params[:reference_link][:referenceable_id].split("-")
        params[:reference_link][:referenceable_type] = type
        params[:reference_link][:referenceable_id] = id
      end
      super
    end

    def create
      if params[:reference_link][:referenceable_id].present? && params[:reference_link][:referenceable_id].include?("-")
        type, id = params[:reference_link][:referenceable_id].split("-")
        params[:reference_link][:referenceable_type] = type
        params[:reference_link][:referenceable_id] = id
      end
      super
    end
  end
end
