require 'acceptance_spec_helper'

feature "Adding and editing goods", js: true, search: true do
  before do
    @admin_user = FactoryGirl.create(:admin_user)
    FactoryGirl.create(:good_with_company)
    @good = FactoryGirl.create(:good, user: @admin_user, company: @admin_user.company)
    login_into_admin
  end

  scenario "As a store admin, I'd like to add images to inventory items" do
    image_path ="#{Rails.root.to_s}/app/assets/images/store/icons/top_empty_cart.png"

    visit admin_inventory_goods_path

    click_link @good.name

    click_link "Gerenciar imagens"
    within('.form-upload') do
      attach_file("good[images_attributes][0][image]",image_path)
      click_button "Enviar arquivos"
    end
    page.should have_content "Imagens atuais"
  end
end
