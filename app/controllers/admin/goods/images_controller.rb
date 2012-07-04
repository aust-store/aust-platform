module Admin
  module Goods
    class ImagesController < Admin::ApplicationController
      def index
        @good = Good.find_and_build_image(params[:good_id])
      end
    end
  end
end
