require_relative 'base_entity'
require_relative 'feed'
require_relative 'operator'

module OnestopRegistry
  module Entities
    class OperatorInFeed
      attr_accessor :gtfs_agency_id, :operator_onestop_id, :feed_onestop_id, :operator, :feed

      def initialize(gtfs_agency_id: nil, operator_onestop_id: nil, feed_onestop_id: nil, operator: nil, feed: nil)
        if operator
          @operator = operator
        elsif operator_onestop_id
          @operator = Operator.new(onestop_id: operator_onestop_id)
        else
          raise ArgumentError.new('an operator object or Onestop ID must be specified')
        end

        if feed
          @feed = feed
        elsif feed_onestop_id
          @feed = Feed.new(onestop_id: feed_onestop_id)
        else
          raise ArgumentError.new('a feed object or Onestop ID must be specified')
        end

        if gtfs_agency_id
          @gtfs_agency_id = gtfs_agency_id
        elsif feed
          # TODO: handle this?
        end

        self
      end
    end
  end
end
