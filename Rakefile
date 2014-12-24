require_relative 'lib/onestop_registry'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task :validate_all_feeds do
  TransitLandFeeds.validate_all_feeds
end

task default: [:spec, :validate_all_feeds]
