class PageDecorator < ApplicationDecorator
  decorates :page

  def body
    model.body
  end
end
