require 'json-schema'

module OnestopRegistry
  JSON::Validator.register_format_validator 'operatorOnestopId', -> (onestop_id) do
    onestop_id_prefix_for_this_object = 'o'
    component_separator = '-'

    errors = []
    is_a_valid_onestop_id = true
    
    if !onestop_id.start_with?(onestop_id_prefix_for_this_object + component_separator)
      errors << "must start with \"#{onestop_id_prefix_for_this_object + component_separator}\" as its 1st component"
      is_a_valid_onestop_id = false
    end
    if onestop_id.split('-').length != 3
      errors << 'must include 3 components separated by hyphens ("-")'
      is_a_valid_onestop_id = false
    end
    if onestop_id.split('-')[1].length == 0 || !!(onestop_id.split('-')[1] =~ /[^a-z\d]/)
      errors << 'must include a valid geohash as its 2nd component, after "o-"'
      is_a_valid_onestop_id = false
    end
    if !!(onestop_id.split('-')[2] =~ /[^a-zA-Z\d]/)
      errors << 'must include only letters and digits in its abbreviated name (the 3rd component)'
      is_a_valid_onestop_id = false
    end
    raise JSON::Schema::CustomFormatError.new(errors.join(', ')) if !is_a_valid_onestop_id
  end

  def self.validate_all_feeds
    errors = {}
    Dir.glob(File.join(__dir__, '..', '..', 'feeds', '*.json')).each do |file_path|
      file = File.open(file_path, 'r')
      file_errors = validate_feed(file.read)
      errors[File.basename(file)] = file_errors if file_errors && file_errors.length > 0
    end
    if errors.length > 0
      puts errors.inspect
    else
      puts "All JSON feed definition files validated."
      Process.exit(0)
    end
  end

  private

  def self.validate_feed(feed_contents)
    JSON::Validator.fully_validate(
      File.join(__dir__, 'feed-schema.json'),
      feed_contents,
      errors_as_objects: true,
      strict: true
    )
  end
end
