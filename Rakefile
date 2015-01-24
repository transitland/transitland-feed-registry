require 'byebug'

require_relative 'lib/onestop_registry'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task :validate_all do
  OnestopRegistry::InternalValidator.validate_all
end

task default: [:spec, :validate_all]
