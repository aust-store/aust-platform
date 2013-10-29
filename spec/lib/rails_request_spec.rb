require "rails_request"

describe RailsRequest do
  subject { described_class.new(request) }

  describe "#current_domain" do
    context "when request is petshop.store.com" do
      let(:request) { double(subdomains: ["petshop"],
                             subdomain:  "petshop",
                             domain:     "store.com") }

      it "returns store.com" do
        expect(subject.current_domain).to eq "store.com"
      end
    end

    context "when request is petshop.store.com.br" do
      let(:request) { double(subdomains: ["petshop", "store"],
                             subdomain:  "petshop.store",
                             domain:     "com.br") }

      it "returns store.com.br" do
        expect(subject.current_domain).to eq "store.com.br"
      end
    end

    context "when request is store.com" do
      let(:request) { double(subdomains: [""],
                             subdomain:  "",
                             domain:     "store.com") }

      it "returns store.com.br" do
        expect(subject.current_domain).to eq "store.com"
      end
    end

    context "when request is store.com.br" do
      let(:request) { double(subdomains: ["store"],
                             subdomain:  "store",
                             domain:     "com.br") }

      it "returns store.com.br" do
        expect(subject.current_domain).to eq "store.com.br"
      end
    end
  end
end
