require_relative 'base_entity'
require_relative 'operator_in_feed'

module OnestopIdRegistry
  module Entities
    class Feed < BaseEntity
      DIRECTORY = File.join(__dir__, '..', '..', '..', 'feeds')

      attr_accessor :onestop_id, :url, :feed_format, :tags, :operators_in_feed

      def initialize(onestop_id: nil, json_blob: nil)
        super(DIRECTORY, onestop_id: onestop_id, json_blob: json_blob)
        @operators_in_feed = create_operators_in_feed(@parsed_json['operatorsInFeed'])
        self
      end

      def self.all(force_reload: false)
        super(DIRECTORY, force_reload: force_reload)
      end

      private

      def create_operators_in_feed(parsed_json_array)
        array = parsed_json_array.map do |parsed_json_object|
          OperatorInFeed.new(feed: self, operator_onestop_id: parsed_json_object['onestopId'], gtfs_agency_id: parsed_json_object['gtfsAgencyId'])
        end
        array
      end

      def map_from_json_properties_to_object_variables(parsed_json)
        [
          ['@onestop_id', 'onestopId'],
          ['@url', 'url'],
          ['@feed_format', 'feedFormat'],
          ['@tags', 'tags'],
        ].each do |mapping|
          instance_variable_set(mapping[0], parsed_json[mapping[1]])
        end
      end
    end
  end
end
