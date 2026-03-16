ActiveAdmin.register Tech do
  config.filters = false

  permit_params :name, :tech_category_id

  index do
    selectable_column
    id_column
    column :name
    column :tech_category do |tech|
      link_to tech.tech_category.name, admin_tech_category_path(tech.tech_category) if tech.tech_category
    end
    column "Projects" do |tech|
      tech.projects.count
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :tech_category do |tech|
        link_to tech.tech_category.name, admin_tech_category_path(tech.tech_category) if tech.tech_category
      end
      row :created_at
      row :updated_at
    end

    panel "Projects Using This Technology" do
      if tech.projects.any?
        table_for tech.projects do
          column :title do |project|
            link_to project.title, admin_project_path(project)
          end
          column :job do |project|
            link_to project.job.company, admin_job_path(project.job)
          end
        end
      else
        div class: "blank_slate_container" do
          span class: "blank_slate" do
            "Not used in any projects yet."
          end
        end
      end
    end
  end
end
