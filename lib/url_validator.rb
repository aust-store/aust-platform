module UrlValidator
  class Url
    def self.validate(url)
       link = url.strip
      return true if link =~ /\Ahttp(s){,1}:/
    end
  end
end
