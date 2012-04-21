class Admin::GoodDecorator < ApplicationDecorator
  decorates :good
  allows :name, :reference, :description
  allows :created_at
end
