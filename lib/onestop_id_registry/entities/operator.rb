require_relative 'base_entity'

module OnestopIdRegistry
  module Entities
    class Operator < BaseEntity
      DIRECTORY = File.join(__dir__, '..', '..', '..', 'operators')

      attr_accessor :onestop_id, :name, :tags, :identifiers, :geometry

      def initialize(onestop_id: nil, json_blob: nil)
        super(DIRECTORY, onestop_id: onestop_id, json_blob: json_blob)
        self
      end

      def self.find_by(us_ntd_id: nil)
        if us_ntd_id
          all.find { |operator| operator.tags['us_national_transit_database_id'] == us_ntd_id }
        else
          raise ArgumentError.new('must specify a US NTD ID')
        end
      end

      def self.all(force_reload: false)
        super(DIRECTORY, force_reload: force_reload)
      end

      private

      def map_from_json_properties_to_object_variables(parsed_json)
        [
          ['@onestop_id', 'onestopId'],
          ['@name', 'name'],
          ['@tags', 'tags'],
          ['@identifiers', 'identifiers'],
          ['@geometry', 'geometry']
        ].each do |mapping|
          instance_variable_set(mapping[0], parsed_json[mapping[1]])
        end
      end
    end
  end
end
