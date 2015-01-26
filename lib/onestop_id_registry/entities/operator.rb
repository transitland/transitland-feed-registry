require_relative 'base_entity'

module OnestopIdRegistry
  module Entities
    class Operator < BaseEntity
      attr_accessor :onestop_id, :name, :tags, :identifiers, :geometry

      def initialize(onestop_id: nil, json_blob: nil)
        super('operators', onestop_id: onestop_id, json_blob: json_blob)
        self
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
