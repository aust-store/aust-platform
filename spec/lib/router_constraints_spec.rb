require "router_constraints"

describe RouterConstraints do
  describe RouterConstraints::Default do
    let(:request) { double }

    subject { RouterConstraints::Default.new }

    describe "#matches?" do
      after do
        subject.matches?(request).should be_true
      end

      it "returns true if it's an iPhone iOS 6.0" do
        request.stub(:env) {
          { "HTTP_USER_AGENT" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.99 Safari/537.22" } }
      end
    end
  end

  describe RouterConstraints::Iphone do
    let(:request) { double }

    subject { RouterConstraints::Iphone.new }

    describe "#matches?" do
      context "matching iPhone iOS 6 or greater" do
        after do
          subject.matches?(request).should be_true
        end

        it "returns true if it's an iPhone iOS 6.0" do
          request.stub(:env) {
            { "HTTP_USER_AGENT" => "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A403 Safari/8536.25" } }
        end

        it "returns true if it's an iPhone iOS 6.1" do
          request.stub(:env) {
            { "HTTP_USER_AGENT" => "Mozilla/5.0 (iPhone; CPU iPhone OS 6_1 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A403 Safari/8536.25" } }

        end

        it "returns true if it's an iPhone iOS 7.0" do
          request.stub(:env) {
            { "HTTP_USER_AGENT" => "Mozilla/5.0 (iPhone; CPU iPhone OS 7_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A403 Safari/8536.25" } }

        end

        it "returns true if it's an iPhone iOS 8.0" do
          request.stub(:env) {
            { "HTTP_USER_AGENT" => "Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A403 Safari/8536.25" } }

        end

        it "returns true if it's an iPhone iOS 88.0" do
          request.stub(:env) {
            { "HTTP_USER_AGENT" => "Mozilla/5.0 (iPhone; CPU iPhone OS 88_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A403 Safari/8536.25" } }

        end
      end

      context "not matching iPhone iOS 6 or greater" do
        after do
          subject.matches?(request).should_not be_true
        end

        it "returns true if it's an iPhone iOS 5.0" do
          request.stub(:env) {
            { "HTTP_USER_AGENT" => "Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A403 Safari/8536.25" } }
        end
      end
    end
  end
end
