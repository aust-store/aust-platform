module Helpers
  module FactoryGirlHelpers
    def create(model_name, options = {})
      FactoryGirl.create(model_name, options)
    end

    def build(model_name, options = {})
      FactoryGirl.build(model_name, options)
    end

    def build_stubbed(model_name, options = {})
      FactoryGirl.build_stubbed(model_name, options)
    end
  end
end

