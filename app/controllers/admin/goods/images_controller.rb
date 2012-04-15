class Admin::Goods::ImagesController < Admin::ApplicationController
  def index
    @good = Good.find params[:good_id]
    @good.good_images.build
  end
end
