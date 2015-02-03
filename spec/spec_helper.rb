require 'byebug'
require 'pry-byebug'

require 'vcr'
require 'webmock/rspec'

require 'simplecov'
if ENV['CIRCLECI'] && ENV['COVERALLS_REPO_TOKEN']
  require 'coveralls'
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
end
SimpleCov.start do
  add_filter 'spec' # ignore spec files
end

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
end

VCR.configure do |c|
  c.cassette_library_dir = File.join(File.dirname(__FILE__), '/test_data/vcr_cassettes')
  c.hook_into :webmock
end
