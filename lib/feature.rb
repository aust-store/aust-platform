class Feature
  def self.alpha(options = {}, &block)
    return if Rails.env.production?
    yield if block_given?
  end

  def self.pre_alpha(options = {}, &block)
    return if Rails.env.production? || Rails.env.staging?
    yield if block_given?
  end
end
