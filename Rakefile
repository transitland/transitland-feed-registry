require 'byebug'
require 'pry-byebug'

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
      puts "and post-processing (to nicely format and to remove unnecessary wrapper elements)"
      OnestopIdRegistry::ComparisonSources::GtfsDataExchange.fetch_and_post_process
      puts "Finished downloading and processing agencies JSON from GTFS Data Exchange API"
    end
  end
end

task :console do
  require 'pry'
  ARGV.clear
  Pry.start
end

task default: [:spec, :validate_all]