require 'acceptance_spec_helper'

feature "Adding and editing goods", js: true, search: true do
  before do
    login_into_admin
    FactoryGirl.create(:good, company: @company)
    @good = FactoryGirl.create(:good, user: @admin_user, company: @company)
  end

  scenario "As a store admin, I'd like to add images to inventory items" do
    image_path ="#{Rails.root.to_s}/app/assets/images/store/icons/top_empty_cart.png"

    visit admin_inventory_goods_path

    click_link @good.name

    click_link "Gerenciar imagens"
    within('.form-upload') do
      attach_file("good[images][image]",image_path)
      click_button "Enviar arquivos"
    end
    visit admin_inventory_good_images_path(@good)
    page.should have_content "Imagens atuais"
  end
end
