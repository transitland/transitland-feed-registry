require 'json-schema'
require_relative 'onestop_id'
require_relative 'entities/feed'
require_relative 'entities/operator'

module OnestopIdRegistry
  module InternalValidator
    ENTITIES_TO_VALIDATE = [:feeds, :operators]

    JSON::Validator.register_format_validator 'operatorOnestopId', -> (onestop_id) do
      is_a_valid_onestop_id, errors = OnestopId.validate_onestop_id_string(onestop_id, expected_entity_type: 'operator')

      begin
        Entities::Operator.new(onestop_id: onestop_id)
      rescue StandardError => e
        is_a_valid_onestop_id = false
        errors << e.message
      end

      raise JSON::Schema::CustomFormatError.new(errors.join(', ')) if !is_a_valid_onestop_id
    end

    JSON::Validator.register_format_validator 'feedOnestopId', -> (onestop_id) do
      is_a_valid_onestop_id, errors = OnestopId.validate_onestop_id_string(onestop_id, expected_entity_type: 'feed')

      begin
        Entities::Feed.new(onestop_id: onestop_id)
      rescue StandardError => e
        is_a_valid_onestop_id = false
        errors << e.message
      end

      raise JSON::Schema::CustomFormatError.new(errors.join(', ')) if !is_a_valid_onestop_id
    end

    def self.validate_all
      errors = {}
      ENTITIES_TO_VALIDATE.each do |entity_to_validate|
        Dir.glob(File.join(__dir__, '..', '..', entity_to_validate.to_s, '*.json')).each do |file_path|
          file = File.open(file_path, 'r')
          # byebug
          file_errors = validate(entity_to_validate, file.read)
          errors[File.basename(file)] = file_errors if file_errors && file_errors.length > 0
        end
      end
      if errors.length > 0
        puts errors.inspect
      else
        puts "All JSON feed definition files validated."
        Process.exit(0)
      end
    end

    private

    def self.validate(entity_type, contents)
      JSON::Validator.fully_validate(
        File.join(__dir__, 'schemas', "#{entity_type}.json"),
        contents,
        errors_as_objects: true,
        strict: true
      )
    end
  end
end
