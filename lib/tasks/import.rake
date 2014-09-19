namespace :docm do
  desc 'load a sql data dump into docm'
  task :load, [] => :environment do |_, args|
  end

  desc 'import a TSV spreadsheet to your local database'
  task :import, [:tsv_path] => :environment do |_, args|
    file_path = args[:tsv_path]
    raise "File #{file_path} not found!" unless File.exists? file_path
    puts 'Importing TSV.'
    Importers::TSV.new(file_path).import!
    puts 'Generating HGVS strings.'
    DataFetchers::HGVS.run
    puts 'Fetching disease information from DiseaseOntology.'
    DataFetchers::DiseaseOntology.run
    puts 'Fetching citations from PubMed.'
    DataFetchers::PubMed.run
    puts 'Looking up previous reference bases in Ensembl.'
    DataFetchers::PreviousBase.run
  end

  task get_disease_names: :environment do
    DataFetchers::DiseaseOntology.run
  end

  task get_pubmed_citations: :environment do
    DataFetchers::PubMed.run
  end

  task generate_hgvs: :environment do
    DataFetchers::HGVS.run
  end

  task populate_previous_bases: :environment do
    DataFetchers::PreviousBase.run
  end
end
