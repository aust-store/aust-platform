class Store::PagesController < Store::ApplicationController
  def show
    page = current_store.pages.find(params[:id])
    @page = DecorationBuilder.pages(page)
  end
end
