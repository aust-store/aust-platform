require 'acceptance_spec_helper'

feature "Inventory Item - Search" do
  before do
    @other_user = create(:admin_user)
    @other_company = @other_user.company
    @other_item = create(:inventory_item,
                         name: "Other item",
                         user: @other_user,
                         company: @other_company)

    @company = create(:barebone_company, handle: "mystore")
    @admin_user = create(:admin_user, company: @company)
    FactoryGirl.create(:taxonomy, store: @company)
    @item = create(:inventory_item,
                   name: "My item",
                   tag_list: %w(item1_tag),
                   user: @admin_user,
                   company: @admin_user.company)

    create(:inventory_item, name: "My item 2", user: @admin_user, company: @admin_user.company)
    login_into_admin
  end

  before do
    visit admin_inventory_items_path
  end

  scenario "As an admin, I search for an item" do
    page.should have_content "Pesquisar"
    #
    # SEARCH NAME
    fill_in "search_query", with: "ite"
    click_button 'Submit'

    page.should have_content "Resultados"
    page.should have_content "My item"
    page.should have_content "My item 2"
    page.should_not have_content @other_item.name
  end
end
