require 'simplecov'
SimpleCov.start do
  add_filter 'spec' # ignore spec files
end

require_relative '../lib/transit_land_feeds'
