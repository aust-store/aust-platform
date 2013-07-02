require 'spec_helper'

describe Theme do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :path }
    it { should validate_uniqueness_of :path }
  end
end
