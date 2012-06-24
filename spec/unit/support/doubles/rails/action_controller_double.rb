module ActionController
  class Base
    def self.before_filter *args
      @@before_filter = args
    end

    def self.before_filter_collection
      @@before_filter
    end

    def redirect_to(*args); end
    def render(*args); end
    def params; {}; end
    def self.protect_from_forgery; {}; end
    def self.layout(*args); {}; end
  end
end
