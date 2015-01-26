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
end

task default: [:spec, :validate_all]