require "uri"

module CommonTools
  class Url
    def initialize(url)
      @url = url
    end

    def valid?
      @url.strip =~ /\Ahttp(s){,1}:/ && !!URI.parse(@url)
    rescue URI::InvalidURIError
      false
    end
  end
end
