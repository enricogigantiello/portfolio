class Language < ApplicationRecord
  extend Mobility
  translates :name, type: :string

  enum :level, {
    a1: "a1",
    a2: "a2",
    b1: "b1",
    b2: "b2",
    c1: "c1",
    c2: "c2",
    native: "native"
  }

  scope :ordered, -> { order(:position) }

  def level_percentage
    percentages = { "a1" => 10, "a2" => 20, "b1" => 40, "b2" => 60, "c1" => 80, "c2" => 95, "native" => 100 }
    percentages[level] || 0
  end
end
