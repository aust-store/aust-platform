require "controllers_extensions/loading_store"

class DummyLoadingStore
  def self.before_filter(args); end

  include ControllersExtensions::LoadingStore
end

describe ControllersExtensions::LoadingStore do
  subject { DummyLoadingStore.new }

  describe "#current_domain" do
    it "returns store.com when request is petshop.store.com" do
      subject.stub(:request) { double(subdomains: ["petshop"],
                                      subdomain:  "petshop",
                                      domain:     "store.com") }
      expect(subject.current_domain).to eq "store.com"
    end

    it "returns store.com.br when request is petshop.store.com.br" do
      subject.stub(:request) { double(subdomains: ["petshop", "store"],
                                      subdomain:  "petshop.store",
                                      domain:     "com.br") }
      expect(subject.current_domain).to eq "store.com.br"
    end

    it "returns store.com.br when request is store.com" do
      subject.stub(:request) { double(subdomains: [""],
                                      subdomain:  "",
                                      domain:     "store.com") }
      expect(subject.current_domain).to eq "store.com"
    end

    it "returns store.com.br when request is store.com.br" do
      subject.stub(:request) { double(subdomains: ["store"],
                                      subdomain:  "store",
                                      domain:     "com.br") }
      expect(subject.current_domain).to eq "store.com.br"
    end
  end
end
