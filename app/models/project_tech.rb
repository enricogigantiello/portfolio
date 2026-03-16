class ProjectTech < ApplicationRecord
  belongs_to :project
  belongs_to :tech

  scope :ordered, -> { order(:position) }
end
