require "securerandom"
require "models/extensions/uuid"

class DummyUuid
  include Models::Extensions::UUID
  def self.before_save(*args); end
  attr_accessor :my_uuid
end

describe Models::Extensions::UUID do
  describe ".uuid" do
    it "generates a UUID string in the my_uuid field" do
      DummyUuid.uuid(field: "my_uuid")
      instance = DummyUuid.new
      instance.generate_uuid
      instance.my_uuid.should =~ /.{8}-.{4}-.{4}-.{12}/
    end
  end
end
