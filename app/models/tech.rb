class Tech < ApplicationRecord
  belongs_to :tech_category
  has_many :project_techs, dependent: :destroy
  has_many :projects, through: :project_techs
end
