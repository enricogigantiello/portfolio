class ProjectAchievement < ApplicationRecord
  extend Mobility
  translates :description, type: :text

  belongs_to :project

  scope :ordered, -> { order(:position) }
end
