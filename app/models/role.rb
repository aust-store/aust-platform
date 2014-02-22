class Role < ActiveRecord::Base
  scope :customer, ->{ where(name: "customer") }
  scope :supplier, ->{ where(name: "supplier") }
end
