module OnestopIdRegistry
  module Entities
    class BaseEntity
      def initialize(directory, onestop_id: nil, json_blob: nil)
        if onestop_id
          begin
            json_file = File.open(File.join(directory, "#{onestop_id}.json"), 'r')
            parsed_json = JSON.parse(json_file.read)
          rescue Errno::ENOENT
            raise StandardError.new("no JSON file found with a Onestop ID of #{onestop_id}")
          end
        elsif json_blob
          parsed_json = JSON.parse(json_blob)
        else
          raise ArgumentError.new('provide a Onestop ID or a JSON blob')
        end

        map_from_json_properties_to_object_variables(parsed_json)

        @parsed_json = parsed_json

        self
      end

      def self.all(directory, force_reload: false)
        if force_reload || !defined?(@entity_objects)
          @entity_objects = []
          files = Dir.glob(File.join(directory, '*.json'))
          files.each do |file_path|
            json_file = File.open(file_path, 'r')
            @entity_objects << new(json_blob: json_file.read)
          end
        end
        @entity_objects
      end
    end
  end
end
