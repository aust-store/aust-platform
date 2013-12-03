require "spec_helper"

describe View::StoreTheme::TemplateElement::Company do
  class DummyCompany
    include View::StoreTheme::TemplateElement::Company

    attr_reader :view

    def initialize(view)
      @view = view
    end
  end

  let(:company) { double(address: address, contact: contact) }
  let(:view)    { double(company: company) }

  let(:address) do
    double(address_1: :address_1,
           address_2: :address_2,
           neighborhood: :neighborhood,
           city: :city,
           state: :state,
           zipcode: :zipcode)
  end

  let(:contact) do
    double(phone_1: :phone_1,
           phone_2: :phone_2,
           email:   :email)
  end

  subject { DummyCompany.new(view) }

  before do
    company.stub(:name) { "Company" }
    company.stub(:build_address)
    company.stub(:build_contact)
  end

  describe "{{{company}}}" do
    it "returns a hash with company's attributes" do
      expect(subject.company).to eq({
        "nome" => "Company",
        "endereco" => {
          "endereco_1" => :address_1,
          "endereco_2" => :address_2,
          "bairro"     => :neighborhood,
          "cidade"     => :city,
          "estado"     => :state,
          "cep"        => :zipcode
        },
        "contato" => {
          "fone_1" => :phone_1,
          "fone_2" => :phone_2,
          "email"  => :email
        }
      })
    end

    it "doesn't build address" do
      company.should_not_receive(:build_address)
      subject.company
    end

    it "doesn't build contact" do
      company.should_not_receive(:build_contact)
      subject.company
    end

    context "address is not present" do
      it "calls build_address on company" do
        company.stub(:address) { nil }
        company.should_receive(:build_address)

        expect { subject.company }.to raise_error
      end
    end

    context "contact is not present" do
      it "calls build_contact on company" do
        company.stub(:contact) { nil }
        company.should_receive(:build_contact)

        expect { subject.company }.to raise_error
      end
    end
  end
end
