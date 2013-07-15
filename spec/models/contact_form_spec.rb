require "spec_helper"

describe ContactForm do
  describe "#headers" do
    it "returns subject, to and from options" do
      c = described_class.new(name: "Alex",
                              email: "user@example.com",
                              message: "Some message",
                              to: "to@person.com")
      c.headers.should == {
        subject: "Formulário de contato",
        to:      "to@person.com",
        reply_to: "Alex <user@example.com>",
        from:     "Contato Aust <contato@austapp.com>"
      }
    end
  end
end

