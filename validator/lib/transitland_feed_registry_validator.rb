require 'json-schema'
require 'transitland_client'

module TransitlandFeedRegistryValidator
  FEED_FOLDER = File.join(__dir__, '..', '..', 'feeds')

  JSON::Validator.register_format_validator 'operatorOnestopId', -> (onestop_id) do
    
    is_a_valid_onestop_id, errors = TransitlandClient::OnestopId.validate_onestop_id_string(onestop_id, expected_entity_type: 'operator')

    raise JSON::Schema::CustomFormatError.new(errors.join(', ')) if !is_a_valid_onestop_id
  end

  JSON::Validator.register_format_validator 'sha1', -> (hash) do
    if hash.match(/^[0-9a-f]{40}$/i) == nil
      raise JSON::Schema::CustomFormatError.new('not a valid sha1 hash')
    end
  end

  JSON::Validator.register_format_validator 'feedOnestopId', -> (onestop_id) do
    is_a_valid_onestop_id, errors = TransitlandClient::OnestopId.validate_onestop_id_string(onestop_id, expected_entity_type: 'feed')

    if !File.exist?(File.join(FEED_FOLDER, "#{onestop_id}.json"))
      is_a_valid_onestop_id = false
      errors < "no file exists at feeds/#{onestop_id}.json"
    end

    raise JSON::Schema::CustomFormatError.new(errors.join(', ')) if !is_a_valid_onestop_id
  end

  def self.validate_all
    errors = {}
    Dir.glob(File.join(FEED_FOLDER, '*.json')).each do |file_path|
      file = File.open(file_path, 'r')
      file_errors = validate('feeds', file.read)
      errors[File.basename(file)] = file_errors if file_errors && file_errors.length > 0
    end
    all_valid = (errors.length == 0)
    return all_valid, errors
  end

  def self.validate_return_errors_and_exit
    all_valid, errors = validate_all
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
      File.join(__dir__, '..', 'json-schemas', "#{entity_type}.json"),
      contents,
      errors_as_objects: true,
      strict: true
    )
  end
end
