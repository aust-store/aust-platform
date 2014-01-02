shared_examples_for "uuid" do |factory, uuid_field_name|
  describe "uuid generation" do
    it "creates a uuid value automatically" do
      created = create(factory, "#{uuid_field_name}" => nil)
      created.should be_valid
      created.public_send(uuid_field_name).should =~ /.{8}-.{4}-.{4}-.{12}/
    end

    it "doesn't regenerate a uuid if it's already present" do
      pre_generated = SecureRandom.uuid
      created = create(factory, "#{uuid_field_name}" => pre_generated)
      created.should be_valid
      created.public_send(uuid_field_name).should == pre_generated
    end
  end
end
