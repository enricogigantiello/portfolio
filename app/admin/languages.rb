ActiveAdmin.register Language do
  config.filters = false

  permit_params :level, :position,
                :name_en, :name_it, :name_de

  index do
    selectable_column
    id_column
    column :name
    column :level do |lang|
      status_tag lang.level.upcase, class: case lang.level
                                           when "native" then "ok"
                                           when "c2", "c1" then "yes"
                                           when "b2", "b1" then "warning"
                                           else "error"
                                           end
    end
    column "Proficiency" do |lang|
      "#{lang.level_percentage}%"
    end
    column :position
    actions
  end

  show do
    attributes_table do
      row :name
      row :level do |lang|
        status_tag lang.level.upcase
      end
      row "Proficiency Percentage" do |lang|
        "#{lang.level_percentage}%"
      end
      row :position
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs "Language Details" do
      f.input :level, as: :select, collection: Language.levels.keys.map { |k| [ k.upcase, k ] }
      f.input :position
    end

    I18n.available_locales.each do |locale|
      f.inputs "Translations (#{locale.to_s.upcase})" do
        f.input :name, as: :string, input_html: { name: "language[name_#{locale}]", value: f.object.send("name_#{locale}") }, label: "Name"
      end
    end

    f.actions
  end
end
