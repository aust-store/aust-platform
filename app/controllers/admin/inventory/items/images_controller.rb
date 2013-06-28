module Admin
  module Inventory
    module Items
      class ImagesController < Admin::ApplicationController
        skip_before_filter :verify_authenticity_token

        def index
          @item = current_company.items.find(params[:item_id])
          @item_images = load_item_images
          @item.images.build
        end

        def create
          @item = current_company.items.find params[:item_id]
          @item.images << InventoryItemImage.new(params[:item][:images])
          if @item.save
            return render partial: "shared/images",
              layout: false,
              locals: { images: load_item_images }
          end
        end

        def update
          if params[:set_cover]
            load_item.images.update_all(cover: false)
            load_item.images.find(params[:id]).update_attributes(cover: true)
          end
          redirect_to admin_inventory_item_images_path
        end

        def destroy
          load_item.images.find(params[:id]).destroy
          redirect_to admin_inventory_item_images_path
        end

        private

        def load_item
          current_company.items.find(params[:item_id])
        end

        def load_item_images
          @item.images.order("id desc, cover desc").dup
        end
      end
    end
  end
end
