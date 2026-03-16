ActiveAdmin.register Job do
  config.filters = false

  permit_params :start_date, :end_date, :position,
                :title_en, :title_it, :title_de,
                :company_en, :company_it, :company_de,
                :role_en, :role_it, :role_de,
                :description_en, :description_it, :description_de,
                projects_attributes: [ :id, :title_en, :title_it, :title_de,
                                       :description_en, :description_it, :description_de,
                                       :role_en, :role_it, :role_de, :position, :_destroy ]

  index do
    selectable_column
    id_column
    column :title
    column :company
    column :role
    column :start_date
    column :end_date do |job|
      job.end_date ? job.end_date : "Present"
    end
    column :position
    column "Projects" do |job|
      job.projects.count
    end
    actions
  end

  show do
    attributes_table do
      row :title
      row :company
      row :description
      row :role
      row :start_date
      row :end_date do |job|
        job.end_date ? job.end_date : "Present"
      end
      row :position
      row :created_at
      row :updated_at
    end

    panel "Projects" do
      table_for job.projects.ordered do
        column :title do |project|
          link_to project.title, admin_project_path(project)
        end
        column :role
        column :position
        column "Achievements" do |project|
          project.project_achievements.count
        end
        column "Technologies" do |project|
          project.techs.count
        end
      end
    end
  end

  form do |f|    f.semantic_errors
    f.inputs "Job Details" do
      f.input :start_date, as: :datepicker
      f.input :end_date, as: :datepicker, hint: "Leave blank if currently employed"
      f.input :position
    end

    I18n.available_locales.each do |locale|
      f.inputs "Translations (#{locale.to_s.upcase})" do
        f.input :title, as: :string, input_html: { name: "job[title_#{locale}]", value: f.object.send("title_#{locale}") }, label: "Title"
        f.input :company, as: :string, input_html: { name: "job[company_#{locale}]", value: f.object.send("company_#{locale}") }, label: "Company"
        f.input :role, as: :string, input_html: { name: "job[role_#{locale}]", value: f.object.send("role_#{locale}") }, label: "Role"
        f.input :description, as: :text, input_html: { name: "job[description_#{locale}]", value: f.object.send("description_#{locale}") }, label: "Description"
      end
    end

    f.inputs "Projects" do
      f.has_many :projects, allow_destroy: true, new_record: "Add Project" do |p|
        p.input :position

        I18n.available_locales.each do |locale|
          p.inputs "Project Translations (#{locale.to_s.upcase})" do
            p.input :title, as: :string, input_html: { name: "job[projects_attributes][#{p.index}][title_#{locale}]", value: p.object.send("title_#{locale}") }, label: "Title"
            p.input :role, as: :string, input_html: { name: "job[projects_attributes][#{p.index}][role_#{locale}]", value: p.object.send("role_#{locale}") }, label: "Role"
            p.input :description, as: :text, input_html: { name: "job[projects_attributes][#{p.index}][description_#{locale}]", value: p.object.send("description_#{locale}") }, label: "Description"
          end
        end
      end
    end

    f.actions
  end
end
