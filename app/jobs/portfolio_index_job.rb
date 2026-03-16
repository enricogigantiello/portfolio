class PortfolioIndexJob < ApplicationJob
  def perform(model_name, record_id)
    record = model_name.constantize.find_by(id: record_id)
    return unless record

    PortfolioIndexer.new.index_record(record)
  end
end
