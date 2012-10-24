module Admin
  module Goods
    class ImagesController < Admin::ApplicationController
      def index
        @good = current_company.items.find(params[:good_id])
        @item_images = load_good_images
        @good.images.build
      end

      def create
        @good = current_company.items.find params[:good_id]
        @good.images << GoodImage.new(params[:good][:images])
        if @good.save
          return render partial: "shared/images",
            layout: false,
            locals: { images: load_good_images }
        end
      end

      def update
        if params[:set_cover]
          load_good.images.update_all(cover: false)
          load_good.images.find(params[:id]).update_attributes(cover: true)
        end
        redirect_to admin_inventory_good_images_path
      end

      def destroy
        load_good.images.find(params[:id]).destroy
        redirect_to admin_inventory_good_images_path
      end

    private

      def load_good
        current_company.items.find(params[:good_id])
      end

      def load_good_images
        @good.images.order("id desc, cover desc").dup
      end
    end
  end
end
