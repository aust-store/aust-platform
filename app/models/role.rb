class Role < ActiveRecord::Base
  scope :customer, ->{ where(name: "customer") }
end
