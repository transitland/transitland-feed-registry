require 'byebug'
require 'pry-byebug'

require 'simplecov'
SimpleCov.start do
  add_filter 'spec' # ignore spec files
end

require_relative '../lib/transitland_feed_registry_validator'

RSpec.configure do |config|
  config.before(:each) do
    stub_const("TransitlandFeedRegistryValidator::FEED_FOLDER", File.join(__dir__, 'test_data'))
  end
end
