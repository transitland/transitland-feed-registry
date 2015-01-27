require 'byebug'

require_relative 'lib/onestop_id_registry'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task :validate_all do
  OnestopIdRegistry::InternalValidator.validate_all
end

namespace :comparison_sources do
  namespace :us_ntd do
    task :fetch do
      puts "Downloading NTD XLS"
      OnestopIdRegistry::ComparisonSources::UsNtd.fetch
      puts "Finished downloading NTD XLS"
    end
  end

  namespace :gtfs_data_exchange do
    task :fetch do
      puts "Downloading agencies JSON from GTFS Data Exchange API"
      OnestopIdRegistry::ComparisonSources::GtfsDataExchange.fetch
      puts "Finished downloading agencies JSON from GTFS Data Exchange API"
      OnestopIdRegistry::ComparisonSources::GtfsDataExchange.post_process
      puts "JSON file is also now post-processed (to remove unnecessary wrapper elements and nicely format)"
    end
  end
end

task default: [:spec, :validate_all]