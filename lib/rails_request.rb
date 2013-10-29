class RailsRequest
  def initialize(request)
    @request = request
  end

  def current_subdomain
    request.subdomains.first if request.subdomains.present?
  end

  def current_domain
    return unless request.domain
    subdomains = request.subdomains

    # takes request.domain and removes double suffixes
    domain_without_double_suffix =
      valid_domain_suffixes.reduce(request.domain) do |memo, suffix|
        memo = memo.gsub("#{suffix}", "")
    end

    # case request.domain is something like "com.br"
    if domain_without_double_suffix == ""
      subdomains.delete_at(0) if request.subdomains.length > 1
      "#{subdomains.join(".")}.#{request.domain}"
    else
      request.domain
    end
  end

  private

  attr_reader :request

  def valid_domain_suffixes
    suffixes = {}
    suffixes[:brazil] = [
      "com", "eco", "emp", "net", "agr", "am", "art", "b", "coop",
      "edu", "esp", "far", "fm", "g12", "gov", "imb", "ind", "inf",
      "jus", "leg", "mil", "mp", "org", "psi", "radio", "rec",
      "srv", "tmp", "tur", "tv", "etc", "adm", "adv", "arq",
      "ato", "bio", "bmd", "cim", "cng", "cnt", "ecn", "eng", "eti",
      "fnd", "fot", "fst", "ggf", "jor", "lel", "mat", "med", "mus",
      "pro", "taxi", "teo", "vet", "blog", "flog", "nom", "vlog", "wiki"
    ].map { |e| e += ".br" }

    suffixes[:england] = ["co.uk"]

    suffixes.each_with_object([]) { |(country, suffix), memo| memo << suffix }.flatten
  end
end
