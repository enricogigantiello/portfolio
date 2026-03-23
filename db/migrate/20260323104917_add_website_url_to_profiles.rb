class AddWebsiteUrlToProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :profiles, :website_url, :string
  end
end
