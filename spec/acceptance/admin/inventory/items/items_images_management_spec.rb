require 'acceptance_spec_helper'

feature "Inventory Items' images management" do
  let(:image_path) { "#{Rails.root.to_s}/spec/support/fixtures/image.png" }

  before do
    login_into_admin
    FactoryGirl.create(:taxonomy, store: @company)
    FactoryGirl.create(:inventory_item, company: @company)
    @item = FactoryGirl.create(:inventory_item, user: @admin_user, company: @company)
  end

  scenario "As a store admin, I'd like to add images to inventory items" do
    visit admin_inventory_items_path

    click_link @item.name

    click_link "Gerenciar imagens"
    current_path.should == admin_inventory_item_images_path(@item)
    within('.form-upload') do
      attach_file("item[images][image]",image_path)
      click_button "Enviar arquivos"
    end

    sleep(1)

    visit admin_inventory_item_images_path(@item)
    page.should have_content /Imagens atuais/i
  end
end
