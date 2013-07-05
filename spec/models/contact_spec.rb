require 'spec_helper'

describe Contact do
  describe "validations" do
    it "validates emails" do
      subject.should     allow_value("user@example.com").for(:email)
      subject.should_not allow_value("http://user@example.com").for(:email)
      subject.should_not allow_value("").for(:email)
    end

    it { should validate_presence_of :phone_1 }
  end
end
