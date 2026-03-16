ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :role

  index do
    selectable_column
    id_column
    column :email
    column :role
    column :created_at
    actions
  end

  filter :email
  filter :role, as: :select, collection: User.roles

  show do
    attributes_table do
      row :email
      row :role
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :role, as: :select, collection: User.roles.keys.map { |r| [ r.capitalize, r ] }
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      super
    end
  end
end
