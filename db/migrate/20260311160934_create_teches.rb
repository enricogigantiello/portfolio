class CreateTeches < ActiveRecord::Migration[8.1]
  def change
    create_table :teches do |t|
      t.string :name
      t.references :tech_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
