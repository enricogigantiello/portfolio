class Profile < ApplicationRecord
  extend Mobility

  translates :title, type: :string
  translates :location, type: :string
  translates :summary_p1, :summary_p2, :summary_p3, type: :text

  has_many :profile_achievements, -> { order(:position) }, dependent: :destroy
  accepts_nested_attributes_for :profile_achievements, allow_destroy: true

  validates :full_name, presence: true

  def self.instance
    first_or_create!(full_name: "Enrico Gigantiello")
  end

  def linkedin_handle
    linkedin_url.to_s.sub(%r{https?://(www\.)?linkedin\.com/}, "")
  end
end
