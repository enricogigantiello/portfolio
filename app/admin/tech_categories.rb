ActiveAdmin.register TechCategory do
  config.filters = false

  permit_params :name, :category_type

  index do
    selectable_column
    id_column
    column :name
    column :category_type do |cat|
      status_tag cat.category_type.humanize
    end
    column "Technologies" do |cat|
      cat.techs.count
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :category_type do |cat|
        status_tag cat.category_type.humanize
      end
      row :created_at
      row :updated_at
    end

    panel "Technologies" do
      if tech_category.techs.any?
        table_for tech_category.techs.order(:name) do
          column :name
          column "Projects" do |tech|
            tech.projects.count
          end
        end
      else
        div class: "blank_slate_container" do
          span class: "blank_slate" do
            "No technologies in this category yet."
          end
        end
      end
    end
  end
end
