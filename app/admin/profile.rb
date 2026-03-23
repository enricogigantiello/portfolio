ActiveAdmin.register Profile do
  config.batch_actions = false

  menu label: "My Profile", priority: 2

  # Always redirect index to the single instance's edit page
  controller do
    def index
      redirect_to edit_admin_profile_path(Profile.instance)
    end

    def new
      redirect_to edit_admin_profile_path(Profile.instance)
    end
  end

  permit_params :full_name, :phone, :email, :linkedin_url, :website_url,
                :title_en, :title_it, :title_de,
                :location_en, :location_it, :location_de,
                :summary_p1_en, :summary_p1_it, :summary_p1_de,
                :summary_p2_en, :summary_p2_it, :summary_p2_de,
                :summary_p3_en, :summary_p3_it, :summary_p3_de,
                profile_achievements_attributes: [
                  :id, :position, :_destroy,
                  :description_en, :description_it, :description_de
                ]

  show do
    attributes_table do
      row :full_name
      row :phone
      row :email
      row :linkedin_url
      row :website_url
      row :title
      row :location
      row :summary_p1
      row :summary_p2
      row :summary_p3
    end

    panel "Achievements" do
      table_for profile.profile_achievements.ordered do
        column :position
        column :description
      end
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs "Personal Info" do
      f.input :full_name
      f.input :phone
      f.input :email
      f.input :linkedin_url, label: "LinkedIn URL"
      f.input :website_url, label: "Website URL"
    end

    I18n.available_locales.each do |locale|
      f.inputs "Header & Summary (#{locale.to_s.upcase})" do
        f.input :title, as: :string,
                input_html: { name: "profile[title_#{locale}]", value: f.object.send("title_#{locale}") },
                label: "Title / Job Title"
        f.input :location, as: :string,
                input_html: { name: "profile[location_#{locale}]", value: f.object.send("location_#{locale}") },
                label: "Location"
        f.input :summary_p1, as: :text,
                input_html: { name: "profile[summary_p1_#{locale}]", value: f.object.send("summary_p1_#{locale}") },
                label: "Summary – Paragraph 1"
        f.input :summary_p2, as: :text,
                input_html: { name: "profile[summary_p2_#{locale}]", value: f.object.send("summary_p2_#{locale}") },
                label: "Summary – Paragraph 2"
        f.input :summary_p3, as: :text,
                input_html: { name: "profile[summary_p3_#{locale}]", value: f.object.send("summary_p3_#{locale}") },
                label: "Summary – Paragraph 3"
      end
    end

    f.inputs "Key Achievements" do
      f.has_many :profile_achievements, allow_destroy: true, new_record: "Add Achievement" do |a|
        a.input :position

        I18n.available_locales.each do |locale|
          a.input :description, as: :text,
                  input_html: {
                    name: "profile[profile_achievements_attributes][#{a.index}][description_#{locale}]",
                    value: a.object.send("description_#{locale}")
                  },
                  label: "Description (#{locale.to_s.upcase})"
        end
      end
    end

    f.actions
  end
end
