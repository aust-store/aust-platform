module CapybaraHelpers
  module StubsHelpers
    def stub_correios
      CompanySetting.any_instance.stub(:valid_zipcode?) { true }
    end
  end
end
