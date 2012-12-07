class CompanySetting < ActiveRecord::Base
  belongs_to :company

  store_accessor :settings, :zipcode

  # defines hstore fields
  ["zipcode"].each do |key|
    attr_accessible key

    define_method(key) { settings && settings[key] }

    define_method("#{key}=") do |value|
      self.settings = (settings || {}).merge(key => value)
    end
  end
end
