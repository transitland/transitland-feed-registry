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

task default: [:spec, :validate_all]
