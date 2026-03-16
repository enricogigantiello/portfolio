class CreateProfileAchievements < ActiveRecord::Migration[8.1]
  def change
    create_table :profile_achievements do |t|
      t.references :profile, null: false, foreign_key: true
      t.integer :position, null: false, default: 0
      t.timestamps
    end
  end
end
