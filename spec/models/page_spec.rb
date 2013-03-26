require 'spec_helper'

describe Page do
  describe "validations" do
    it "validates titles" do
      subject.should     allow_value("something").for(:title)
      subject.should_not allow_value("").for(:title)
    end
  end
end
