class AppConfig

  # Allows developers to use simpler commands such as AppConfig.google_analytics?
  # in views and other places. It uses whatever was loaded in the CONFIG
  # constant.
  #
  # If CONFIG has a key `google_analytics`, you can use either one of the following:
  #
  #   - AppConfig.google_analytics
  #   - AppConfig.google_analytics? (this version casts the value to boolean)
  def self.method_missing(original_method, *args, &block)
    question_method = original_method.to_s.scan(/\?\Z/)
    method = original_method.to_s.gsub(/\?\Z/, "")
    if config.keys.include?(method)
      if question_method
        !!config[method]
      else
        config[method]
      end
    else
      super
    end
  end


  def self.config
    CONFIG
  end
end
