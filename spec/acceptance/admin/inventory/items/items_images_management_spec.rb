require 'acceptance_spec_helper'

feature "Inventory Items' images management", js: true, search: true do
  let(:image_path) { "#{Rails.root.to_s}/app/assets/images/store/icons/top_empty_cart.png" }
  before do
    login_into_admin
    FactoryGirl.create(:inventory_item, company: @company)
    @item = FactoryGirl.create(:inventory_item, user: @admin_user, company: @company)
  end

  scenario "As a store admin, I'd like to add images to inventory items" do
    visit admin_inventory_items_path

    click_link @item.name

    click_link "Gerenciar imagens"
    within('.form-upload') do
      attach_file("item[images][image]",image_path)
      click_button "Enviar arquivos"
    end
    visit admin_inventory_item_images_path(@item)
    page.should have_content "Imagens atuais"
  end
end
