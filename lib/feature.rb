class Feature
  def self.alpha(options = {}, &block)

    if ::Rails.env.production?
      if options && options[:allow_company] && options[:handle]
        return unless options[:allow_company].include?(options[:handle])
      else
        return
      end
    end
    yield if block_given?
  end

  def self.pre_alpha(options = {}, &block)
    return if ::Rails.env.production? || Rails.env.staging?
    yield if block_given?
  end
end
