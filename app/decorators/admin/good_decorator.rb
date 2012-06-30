module Admin
  class GoodDecorator < ApplicationDecorator
    decorates :good

    def has_image?
      good.images.present?
    end
  end
end
