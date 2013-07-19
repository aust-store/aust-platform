# encoding: utf-8
require 'acceptance_spec_helper'

feature "Company ad banners" do
  let(:image_path) { "#{Rails.root.to_s}/spec/support/fixtures/image.png"  }

  before do
    login_into_admin
    stub_subdomain(@admin_user.company)

    visit admin_settings_path
  end

  scenario "As an admin, I want to add banners to my store" do
    click_link I18n.t("admin.navigation.banners")
    page.first(:link, I18n.t("admin.banners.index.new_banner")).click

    fill_in I18n.t("activerecord.attributes.banner.title"),    with: "My good banner"
    fill_in I18n.t("activerecord.attributes.banner.url"),      with: "http://www.google.com/"
    attach_file I18n.t("activerecord.attributes.banner.image"), image_path

    click_button I18n.t('admin.banners.form.save')

    page.should have_content("My good banner")
  end

  scenario "As an Admin, I shouldn't be able to add a invalid banner" do
    click_link I18n.t("admin.navigation.banners")
    page.first(:link,I18n.t("admin.banners.index.new_banner")).click

    fill_in I18n.t("activerecord.attributes.banner.title"),    with: ""
    fill_in I18n.t("activerecord.attributes.banner.url"),      with: "invalid"

    click_button I18n.t('admin.banners.form.save')

    page.should have_content(I18n.t("activerecord.errors.models.banner.attributes.title.blank"))
  end

  scenario "As an Admin, I can't add more than 3 banners" do
    3.times do
      create(:banner, company: @admin_user.company)
    end

    click_link I18n.t("admin.navigation.banners")
    page.should have_content(I18n.t("admin.banners.message.full"))
  end

  scenario "As an Admin, I want to edit a banner" do
    banner = create(:banner, company: @admin_user.company)

    click_link I18n.t("admin.navigation.banners")
    click_link banner.title
    fill_in I18n.t("activerecord.attributes.banner.title"),    with: "My good banner edited"
    click_button I18n.t('admin.banners.form.save')

    page.should have_content("My good banner edited")
  end

end
