require "rails_request"

shared_examples_for "a rails request" do
  subject { RailsRequest.new(double.as_null_object) }

  it "responds to current_subdomain" do
    subject.should respond_to(:current_subdomain)
  end

  it "responds to current_domain" do
    subject.should respond_to(:current_domain)
  end
end
