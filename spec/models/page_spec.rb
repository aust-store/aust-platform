require 'spec_helper'

describe Page do
  describe "validations" do
    it { should validate_presence_of :company }
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end
end
