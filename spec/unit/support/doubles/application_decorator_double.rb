class ApplicationDecorator
  def initialize(decorated); end

  def self.decorates *args
    @@decorated ||= {}
    class_name = self.to_s
    @@decorated[class_name] = [] unless @@decorated.has_key? class_name
    @@decorated[class_name] << args
  end

  def self.decorated_collection
    Array(@@decorated[self.to_s])
  end

  def self.allows *args
    @@allowed ||= {}
    class_name = self.to_s
    @@allowed[class_name] = [] unless @@allowed.has_key? class_name
    @@allowed[class_name] << args
  end

  def self.allowed_collection
    @@allowed[self.to_s].flatten
  end
end
