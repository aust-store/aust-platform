require "store/company/domain_sanitizer"

describe Store::Company::DomainSanitizer do
  sanitizing_rules = [
    ["",                      ""],
    [nil,                     ""],
    [1,                       ""],
    [true,                    ""],
    ["www.domain.com",        "domain.com"],
    ["ww.domain.com",         "domain.com"],
    ["w.domain.com",          "domain.com"],
    [".domain.com",           "domain.com"],
    ["www.domain.com/",       "domain.com"],
    ["www.//domain.com//",    "domain.com"],
    ["http://www.domain.com", "domain.com"],
    ["http:/www.domain.com",  "domain.com"],
    ["http:www.domain.com",   "domain.com"],
    ["http://dom.comhttp://", "dom.com"],
    [" http://.domain.com ",  "domain.com"],
    [".domain.com",           "domain.com"],
    [".domain.com.",          "domain.com"],
    [".domain.com?q=store",   "domain.com"],
    ["domain.com.br",         "domain.com.br"],
    ["<d123o^*m-_ain.com!-_", "d123om-_ain.com"],
  ]

  describe "sanitize" do
    sanitizing_rules.each do |e|
      it "sanitizes #{e[0]} into #{e[1]}" do
        expect(described_class.new(e[0]).sanitize).to eq e[1]
      end
    end
  end
end
