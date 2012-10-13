module Admin
  module Goods
    class ImagesController < Admin::ApplicationController
      def index
        @good = current_company.items.find(params[:good_id])
        @item_images = @good.images.dup
        @good.images.build
      end
    end
  end
end
