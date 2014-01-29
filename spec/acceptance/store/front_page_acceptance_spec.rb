# coding: utf-8
require 'acceptance_spec_helper'

feature "Store's front-page" do
  before do
    @company = FactoryGirl.create(:company)
    stub_subdomain(@company)

    # adding data to be able to test it
    FactoryGirl.create(:inventory_item, company: @company)

    @item = FactoryGirl.create(:inventory_item, company: @company)
    @item.entries.first.update_attribute(:quantity, 0)
  end

  describe "Accessing a company's store" do
    scenario "As a customer, I access a specific store" do
      visit root_path
      page.should have_content(@company.name)

      within(".cart_status") do
        page.should have_content("Seu carrinho está vazio.")
      end

      # the correct price is shown
      page.should have_content @item.name
      page.should have_content "R$ 12,34"
    end
  end

  describe "Showing highlight products in the main page" do
    scenario "As a customer, I see a list of highlight products, max 12 results" do
      12.times do |i|
        inventory_entry = FactoryGirl.attributes_for(:inventory_entry)
        FactoryGirl.create(:inventory_item,
                           name: "Item #{i}",
                           company: @company,
                           entries_attributes: [inventory_entry])
      end

      visit root_path
      page.should have_content(@company.name)

      n = 11
      12.times do |index|
        within(".product_#{index}") do
          page.should have_content "Item #{n}" # order of products :)
          page.has_css?("image_#{index}")
          page.should have_content "R$ 12,34"
        end
        n -= 1
      end
    end

    scenario "As customer, I see the cover images in products" do
      cover_image = @item.images.cover.first
      cover_image_url = cover_image.image.url(:cover_standard)
      visit root_path
      page.should have_selector "img[src='#{cover_image_url}']"
    end
  end

  describe "products not shown for sale on main page" do
    scenario "items without a valid shipping box, do not appears on main page" do
      visit root_path
      page.should have_content @item.name
      @item.update_attributes(shipping_box: nil)
      visit root_path
      page.should_not have_content @item.name
    end

    scenario "items without an entry for website sale" do
      @item.entries.size.should == 3
      visit root_path
      page.should have_content @item.name
      @item.entries.each { |entry| entry.update_attributes(website_sale: false) }
      visit root_path
      page.should_not have_content @item.name
    end

    scenario "items without a cover image, do not appears on main page" do
      visit root_path
      page.should have_content @item.name

      InventoryItem.find_by_name(@item.name).images.cover.to_a.each do |e|
        e.update_attributes(cover: false)
      end

      visit root_path
      page.should_not have_content @item.name
    end
  end
end
