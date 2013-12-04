class Url
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
