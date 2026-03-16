class Education < ApplicationRecord
  extend Mobility
  translates :degree, :institution, type: :string
  translates :description, type: :text

  scope :ordered, -> { order(:position) }

  after_commit :reindex_for_rag



  def grade_percentage
    return 0 if grade_max.nil? || grade_min.nil? || (grade_max - grade_min).zero?

    if grade_max < grade_min
      # German system: max=1.0 (best), min=5.0 (worst) - lower is better
      # Formula: (min - grade) / (min - max) * 100
      # Example: 1.6 grade → (5.0 - 1.6) / (5.0 - 1.0) = 85%
      ((grade_min - grade) / (grade_min - grade_max) * 100).round(2)
    else
      # Normal system: max=110 (best), min=0 (worst) - higher is better
      # Formula: (grade - min) / (max - min) * 100
      # Example: 106 grade → (106 - 0) / (110 - 0) = 96.36%
      ((grade - grade_min) / (grade_max - grade_min) * 100).round(2)
    end
  end

  def self.ransackable_associations(auth_object = nil)
    [ "string_translations" ]
  end
  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "id_value", "key", "locale", "translatable_id", "translatable_type", "updated_at", "value" ]
  end

    private

  def reindex_for_rag
    PortfolioIndexJob.perform_later(self.class.name, id)
  end
end
