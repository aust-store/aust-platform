class JsonRequestParser
  def initialize(json_object)
    @json_object = json_object
  end

  # Rails expects hashes that are used to create new ActiveRecord objects to
  # have nested objects with an "_attributes" suffix, like the following:
  #
  #   { "order" => { "items_attributes" => { "price" => 123 } } }
  #
  # It doesn't make sense to subject Ember-Data, for example, to send object
  # like that to please Rails. So this method converts the following example
  # into the one shown before:
  #
  #   { "order" => { "items" => { "price" => 123 } } }
  #
  def add_attributes_suffix
    new_params = {}
    @json_object.each do |first_level_key, first_level_value|
      next unless first_level_value.is_a?(Hash)

      first_level_value.each do |key, value|
        if value.is_a?(Hash) || value.is_a?(Array)
          value = { "#{key}_attributes" => value }
        end
        new_params[first_level_key.to_s] = value
      end
    end

    new_params
  end
end
