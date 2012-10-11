module Admin
  module Goods
    class ImagesController < Admin::ApplicationController
      def index
        @good = Good.find(params[:good_id])
        @good_images = @good.images.dup
        @good.images.build
      end
    end
  end
end
