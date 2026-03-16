class ProfileAchievement < ApplicationRecord
  extend Mobility
  translates :description, type: :text

  belongs_to :profile

  scope :ordered, -> { order(:position) }
end
