shared_examples_for "addressable" do |factory_girl_name|
  describe "default address for addressable model" do
    it "creates the address as default" do
      addressable = FactoryGirl.create(factory_girl_name)
      addressable.addresses.first.default.should be_true

      FactoryGirl.create(:address, addressable: addressable, address_1: "New address")
      addresses = addressable.addresses.order("id").to_a
      addresses[0].default.should be_true
      addresses[1].default.should be_false
    end
  end
end
