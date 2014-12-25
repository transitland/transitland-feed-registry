class OnestopID
  self.ENTITY_TO_PREFIX = {
    'stop' => 's',
    'operator' => 'o'
  }
  self.PREFIX_TO_ENTITY = ENTITY_TO_PREFIX.invert
  self.COMPONENT_SEPARATOR = COMPONENT_SEPARATOR

  attr_accessor :entity_prefix, :geohash, :name

  def initialize(string)
    is_a_valid_onestop_id, errors = validate_onestop_id_string(string)
    if is_a_valid_onestop_id
      @entity_prefix = string.split(COMPONENT_SEPARATOR)[0]
      @geohash = string.split(COMPONENT_SEPARATOR)[1]
      @name = string.split(COMPONENT_SEPARATOR)[2]
      self
    else
      raise ArgumentError.new(errors.join(', '))
    end
  end

  def initialize(entity_prefix, geohash, name)
    errors = []
    if valid_component?(:entity_prefix, entity_prefix)
      @entity_prefix = entity_prefix
    else
      errors << 'invalid entity prefix'
    end
    if valid_component?(:geohash, geohash)
      @geohash = geohash
    else
      errors << 'invalid geohash'
    end
    if valid_component?(:name, name)
      @name = name
    else
      errors << 'invalid name'
    end

    if errors.length > 0
      raise ArgumentError.new(errors.join(', '))
    else
      self
    end
  end

  private

  def self.validate_onestop_id_string(onestop_id)
    errors = []
    is_a_valid_onestop_id = true
    
    if onestop_id.split(COMPONENT_SEPARATOR).length != 3
      errors << 'must include 3 components separated by hyphens ("-")'
      is_a_valid_onestop_id = false
    end
    if !valid_component?(:entity_prefix, onestop_id.split(COMPONENT_SEPARATOR)[0])
      errors << "must start with \"#{ENTITY_TO_PREFIX.values.join(' or ')}\" as its 1st component"
      is_a_valid_onestop_id = false
    end
    if onestop_id.split(COMPONENT_SEPARATOR)[1].length == 0 || !valid_component?(:geohash, onestop_id.split(COMPONENT_SEPARATOR)[1])
      errors << 'must include a valid geohash as its 2nd component, after "o-"'
      is_a_valid_onestop_id = false
    end
    if !valid_component?(:name, onestop_id.split(COMPONENT_SEPARATOR)[2])
      errors << 'must include only letters and digits in its abbreviated name (the 3rd component)'
      is_a_valid_onestop_id = false
    end

    is_a_valid_onestop_id, errors
  end

  def self.valid_component?(component, value)
    case component
    when :entity_prefix then ENTITY_TO_PREFIX.values.include?(value)
    when :geohash then value =~ /[^a-z\d]/
    when :name then value =~ /[^a-zA-Z\d]/
    else false
  end
end
