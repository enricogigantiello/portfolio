ActiveAdmin.register Project do
  config.filters = false

  permit_params :job_id, :position,
                :title_en, :title_it, :title_de,
                :description_en, :description_it, :description_de,
                :role_en, :role_it, :role_de,
                :tile_image, :cover_image,
                tech_ids: [],
                project_achievements_attributes: [ :id, :description_en, :description_it, :description_de, :position, :_destroy ],
                reference_links_attributes: [ :id, :label_en, :label_it, :label_de, :url, :link_type, :position, :_destroy ]

  index do
    selectable_column
    id_column
    column :title
    column :job do |project|
      link_to project.job.company, admin_job_path(project.job)
    end
    column :role
    column "Technologies" do |project|
      project.techs.count
    end
    column "Achievements" do |project|
      project.project_achievements.count
    end
    column "Links" do |project|
      project.reference_links.count
    end
    column :position
    actions
  end

  show do
    attributes_table do
      row :title
      row :job do |project|
        link_to project.job.company, admin_job_path(project.job)
      end
      row :description
      row :role
      row :position
      row :tile_image do |project|
        if project.tile_image.attached?
          image_tag url_for(project.tile_image), style: "max-width: 200px; height: auto;"
        else
          status_tag "No image", class: "warning"
        end
      end
      row :cover_image do |project|
        if project.cover_image.attached?
          image_tag url_for(project.cover_image), style: "max-width: 200px; height: auto;"
        else
          status_tag "No image", class: "warning"
        end
      end
      row :created_at
      row :updated_at
    end

    panel "Technologies" do
      if project.techs.any?
        table_for project.techs do
          column :name
          column :tech_category do |tech|
            tech.tech_category.name
          end
        end
      else
        div class: "blank_slate_container" do
          span class: "blank_slate" do
            "No technologies assigned yet."
          end
        end
      end
    end

    panel "Achievements" do
      if project.project_achievements.any?
        table_for project.project_achievements.ordered do
          column :description
          column :position
        end
      else
        div class: "blank_slate_container" do
          span class: "blank_slate" do
            "No achievements added yet."
          end
        end
      end
    end

    panel "Reference Links" do
      if project.reference_links.any?
        table_for project.reference_links.ordered do
          column :label
          column :url do |link|
            link_to link.url, link.url, target: "_blank"
          end
          column :link_type
          column :position
        end
      else
        div class: "blank_slate_container" do
          span class: "blank_slate" do
            "No reference links added yet."
          end
        end
      end
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs "Project Details" do
      f.input :job, as: :select, collection: Job.order(:company).map { |j| [ "#{j.company} - #{j.title}", j.id ] }
      f.input :position
      f.input :tile_image, as: :file, hint: (f.object.tile_image.attached? ? image_tag(url_for(f.object.tile_image), style: "max-width: 200px; height: auto;") : content_tag(:span, "No image uploaded"))
      f.input :cover_image, as: :file, hint: (f.object.cover_image.attached? ? image_tag(url_for(f.object.cover_image), style: "max-width: 200px; height: auto;") : content_tag(:span, "No image uploaded"))
    end

    I18n.available_locales.each do |locale|
      f.inputs "Translations (#{locale.to_s.upcase})" do
        f.input :title, as: :string, input_html: { name: "project[title_#{locale}]", value: f.object.send("title_#{locale}") }, label: "Title"
        f.input :role, as: :string, input_html: { name: "project[role_#{locale}]", value: f.object.send("role_#{locale}") }, label: "Role"
        f.input :description, as: :text, input_html: { name: "project[description_#{locale}]", value: f.object.send("description_#{locale}") }, label: "Description"
      end
    end

    f.inputs "Technologies" do
      Tech.includes(:tech_category).order(:name).group_by(&:tech_category).each do |category, techs|
        f.inputs category.name, class: "tech-category" do
          f.input :techs, as: :check_boxes, collection: techs, label_method: :name, value_method: :id
        end
      end
    end

    f.inputs "Achievements" do
      f.has_many :project_achievements, allow_destroy: true, new_record: "Add Achievement" do |a|
        a.input :position

        I18n.available_locales.each do |locale|
          a.inputs "Achievement Translation (#{locale.to_s.upcase})" do
            a.input :description, as: :text, input_html: { name: "project[project_achievements_attributes][#{a.index}][description_#{locale}]", value: a.object.send("description_#{locale}") }, label: "Description"
          end
        end
      end
    end

    f.inputs "Reference Links" do
      f.has_many :reference_links, allow_destroy: true, new_record: "Add Link" do |l|
        l.input :url
        l.input :link_type, as: :select, collection: ReferenceLink.link_types.keys.map { |k| [ k.humanize, k ] }
        l.input :position

        I18n.available_locales.each do |locale|
          l.inputs "Link Label Translation (#{locale.to_s.upcase})" do
            l.input :label, as: :string, input_html: { name: "project[reference_links_attributes][#{l.index}][label_#{locale}]", value: l.object.send("label_#{locale}") }, label: "Label"
          end
        end
      end
    end

    f.actions
  end
end
