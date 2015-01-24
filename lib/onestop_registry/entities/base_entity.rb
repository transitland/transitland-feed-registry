module OnestopRegistry
  module Entities
    class BaseEntity
      def initialize(entity, onestop_id: nil, json_blob: nil)
        if onestop_id
          begin
            json_file = File.open(File.join(__dir__, '..', '..', '..', entity, "#{onestop_id}.json"), 'r')
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
    end
  end
end
