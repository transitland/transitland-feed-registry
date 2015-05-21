require 'byebug'
require 'pry-byebug'

require 'simplecov'
SimpleCov.start do
  add_filter 'spec' # ignore spec files
end

require_relative '../lib/transitland_feed_registry_validator'
