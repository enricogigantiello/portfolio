ActiveAdmin.register ProjectAchievement do
  config.filters = false

  permit_params :project_id, :position,
                :description_en, :description_it, :description_de

  index do
    selectable_column
    id_column
    column :description, sortable: false
    column :project do |achievement|
      link_to achievement.project.title, admin_project_path(achievement.project) if achievement.project
    end
    column :position
    actions
  end

  show do
    attributes_table do
      row :description
      row :project do |achievement|
        link_to achievement.project.title, admin_project_path(achievement.project) if achievement.project
      end
      row :position
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs "Achievement Details" do
      f.input :project, as: :select, collection: Project.order(:title).map { |p| [ p.title, p.id ] }
      f.input :position
    end

    I18n.available_locales.each do |locale|
      f.inputs "Translations (#{locale.to_s.upcase})" do
        f.input :description, as: :text, input_html: { name: "project_achievement[description_#{locale}]", value: f.object.send("description_#{locale}") }, label: "Description"
      end
    end

    f.actions
  end
end
