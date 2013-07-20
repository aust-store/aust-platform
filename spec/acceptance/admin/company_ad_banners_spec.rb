# encoding: utf-8
require 'acceptance_spec_helper'

feature "Company ad banners" do
  let(:image_path) { "#{Rails.root.to_s}/spec/support/fixtures/image.png" }

  before do
    login_into_admin
    stub_subdomain(@admin_user.company)

    visit admin_marketing_index_path
  end

  describe "Banners" do
    background do
      click_link I18n.t("admin.navigation.banners")
      page.first(:link, I18n.t("admin.banners.index.new_banner")).click
      fill_in I18n.t("activerecord.attributes.banner.title"),     with: "My good banner"
      fill_in I18n.t("activerecord.attributes.banner.url"),       with: "http://www.google.com/"
      attach_file I18n.t("activerecord.attributes.banner.image"), image_path
    end

    scenario "As an admin, I want to add all_pages_right banners" do
      select I18n.t('activerecord.values.banner.position.all_pages_right'), from: "banner[position]"

      click_button "submit"
      assert_banner("all_pages_right", ".all_pages_right_ad_banners")
    end

    scenario "As an admin, I want to add main_page_central_rotative banners" do
      select I18n.t('activerecord.values.banner.position.main_page_central_rotative'), from: "banner[position]"

      click_button "submit"
      assert_banner("main_page_central_rotative", ".main_page_central_transitional_banners")
    end

    # checks the banners list in the admin and then visits the store to check
    # if the banner is there
    def assert_banner(position, store_position_class)
      page.should have_content("My good banner")
      page.should have_content I18n.t("activerecord.values.banner.position.#{position}")
      Banner.first.image.url.should_not == ""

      # The banner is added to the store's homepage
      visit root_path
      within(store_position_class) do
        find("img")[:src].should == Banner.first.image.url
      end
    end
  end

  describe "Max banners allowed per position" do
    scenario "As an Admin, I can't add more than 3 banners" do
      3.times do
        create(:banner, company: @admin_user.company, position: "all_pages_right")
      end

      visit new_admin_banner_path
      attach_file I18n.t("activerecord.attributes.banner.image"), image_path

      # selects <option> by value
      find("option[value='all_pages_right']").click

      click_button "submit"
      page.should have_content I18n.t("activerecord.errors.models.banner.attributes.position.quantity")
    end
  end

  scenario "As an Admin, I want to edit a banner" do
    banner = create(:banner, company: @admin_user.company)

    click_link I18n.t("admin.navigation.banners")
    click_link banner.title
    fill_in I18n.t("activerecord.attributes.banner.title"), with: "My good banner edited"
    click_button "submit"

    page.should have_content("My good banner edited")
  end

  scenario "As an Admin, I shouldn't be able to add an invalid banner" do
    click_link I18n.t("admin.navigation.banners")
    page.first(:link,I18n.t("admin.banners.index.new_banner")).click

    fill_in I18n.t("activerecord.attributes.banner.title"), with: ""
    fill_in I18n.t("activerecord.attributes.banner.url"),   with: "invalid"

    click_button "submit"

    page.should have_content(I18n.t("activerecord.errors.models.banner.attributes.title.blank"))
  end
end
