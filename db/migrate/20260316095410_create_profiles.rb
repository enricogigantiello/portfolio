class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles do |t|
      t.string :full_name, null: false, default: ""
      t.string :phone
      t.string :email
      t.string :linkedin_url
      t.timestamps
    end
  end
end
