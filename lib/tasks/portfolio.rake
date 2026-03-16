namespace :portfolio do
  desc "Generate embeddings for all portfolio content (jobs, projects, education, languages)"
  task index: :environment do
    puts "Indexing portfolio content..."
    indexer = PortfolioIndexer.new
    indexer.call
    puts "Done. Total documents: #{PortfolioDocument.count}"
  end

  desc "Clear all portfolio embeddings and re-index"
  task reindex: :environment do
    puts "Clearing existing portfolio documents..."
    PortfolioDocument.delete_all
    Rake::Task["portfolio:index"].invoke
  end
end
