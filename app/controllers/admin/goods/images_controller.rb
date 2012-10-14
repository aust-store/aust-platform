module Admin
  module Goods
    class ImagesController < Admin::ApplicationController
      def index
        @good = current_company.items.find(params[:good_id])
        @item_images = @good.images.dup
        @good.images.build
      end

      def create
        @good = current_company.items.find params[:good_id]
        @good.images << GoodImage.new(params[:good][:images])
        if @good.save
          return render partial: "shared/images",
            layout: false,
            locals: { images: @good.images.dup }
        end
      end
    end
  end
end
