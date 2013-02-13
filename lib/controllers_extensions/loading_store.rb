module ControllersExtensions
  module LoadingStore
    def self.included(base)
      base.before_filter :load_store_information
    end

    def current_store
      @company ||= load_store_information
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

    def current_subdomain
      request.subdomains.first if request.subdomains.present?
    end

    private

    def load_store_information
      Rails.logger.info "Visiting with subdomain: #{current_subdomain} - domain: #{current_domain}"
      @company ||= Company.where("handle = ? OR domain = ?",
                                 current_subdomain,
                                 current_domain).first
    end

    def valid_domain_suffixes
      brazil = ["com", "eco", "emp", "net", "agr", "am", "art", "b", "coop",
                "edu", "esp", "far", "fm", "g12", "gov", "imb", "ind", "inf",
                "jus", "leg", "mil", "mp", "org", "psi", "radio", "rec",
                "srv", "tmp", "tur", "tv", "etc", "adm", "adv", "arq",
                "ato", "bio", "bmd", "cim", "cng", "cnt", "ecn", "eng", "eti",
                "fnd", "fot", "fst", "ggf", "jor", "lel", "mat", "med", "mus",
                "pro", "taxi", "teo", "vet", "blog", "flog", "nom", "vlog",
                "wiki"].map { |e| e += ".br" }

      england = ["co.uk"]

      england + brazil
    end
  end
end
