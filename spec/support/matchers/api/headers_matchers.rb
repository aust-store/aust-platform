require 'rspec/expectations'

RSpec::Matchers.define :have_proper_api_headers do
  match do |response|
    return true if response.blank?

    expectations.all? do |name, expected_value|
      Array(response.headers[name]).include?(expected_value)
    end.should be_true
  end

  failure_message_for_should do |response|
    broken = expectations.find do |name, expected_value|
      !Array(response.headers[name]).include?(expected_value)
    end
    "expected \"#{broken[0]}\" header to equal \"#{broken[1]}\" instead of \"#{response.headers[broken[0]]}\""
  end

  def expectations
    { "Endpoint-Purpose" => "point_of_sale",
      "Access-Control-Allow-Origin" => "http://localhost:4200" }
  end
end
