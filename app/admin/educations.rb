ActiveAdmin.register Education do
  config.filters = false

  permit_params :start_date, :end_date, :grade, :grade_min, :grade_max, :position,
                :degree_en, :degree_it, :degree_de,
                :institution_en, :institution_it, :institution_de,
                :description_en, :description_it, :description_de

  index do
    selectable_column
    id_column
    column :degree
    column :institution
    column :start_date
    column :end_date do |edu|
      edu.end_date ? edu.end_date : "Present"
    end
    column :grade do |edu|
      "#{edu.grade} / #{edu.grade_max}" if edu.grade && edu.grade_max
    end
    column "Performance" do |edu|
      "#{edu.grade_percentage.round(1)}%" if edu.grade && edu.grade_max
    end
    column :position
    actions
  end

  show do
    attributes_table do
      row :degree
      row :institution
      row :description
      row :start_date
      row :end_date do |edu|
        edu.end_date ? edu.end_date : "Present"
      end
      row :grade
      row :grade_min
      row :grade_max
      row "Grade Percentage" do |edu|
        "#{edu.grade_percentage.round(2)}%" if edu.grade && edu.grade_max
      end
      row :position
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs "Education Details" do
      f.input :start_date, as: :datepicker
      f.input :end_date, as: :datepicker, hint: "Leave blank if ongoing"
      f.input :grade
      f.input :grade_min
      f.input :grade_max
      f.input :position
    end

    I18n.available_locales.each do |locale|
      f.inputs "Translations (#{locale.to_s.upcase})" do
        f.input :degree, as: :string, input_html: { name: "education[degree_#{locale}]", value: f.object.send("degree_#{locale}") }, label: "Degree"
        f.input :institution, as: :string, input_html: { name: "education[institution_#{locale}]", value: f.object.send("institution_#{locale}") }, label: "Institution"
        f.input :description, as: :text, input_html: { name: "education[description_#{locale}]", value: f.object.send("description_#{locale}") }, label: "Description"
      end
    end

    f.actions
  end
end
