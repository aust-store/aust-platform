require "acceptance_spec_helper"

feature "Store - categories of producs" do
  let(:parent)           { create(:single_taxonomy,
                                  store: company,
                                  name: "Roupas") }

  let(:t_shirt_category) { create(:single_taxonomy,
                                  store: company,
                                  name: "Camisetas",
                                  parent: parent) }

  let(:pants_category)   { create(:single_taxonomy,
                                  store: company,
                                  name: "Calças",
                                  parent: parent) }

  let(:company) { create(:company) }
  let(:t_shirt) { create(:inventory_item,
                         company: company,
                         taxonomy:
                         t_shirt_category) }
  let(:pants)   { create(:inventory_item,
                         company: company,
                         taxonomy: pants_category) }

  background do
    stub_subdomain(company)

    # creates the categories
    t_shirt_category and pants_category

    # products
    t_shirt and pants
  end

  scenario "As an user, I can see a products in their category pages" do
    visit root_path

    page.should have_content pants.name
    page.should have_content t_shirt.name

    # visits the categories to see the products
    within "[name='taxonomy_menu']" do
      click_link "Calças"
    end
    page.should     have_content pants.name
    page.should_not have_content t_shirt.name
    find("a.category_#{pants_category.id}")[:class].should =~ /current/
    find("a.category_#{t_shirt_category.id}")[:class].should_not =~ /current/

    within "[name='taxonomy_menu']" do
      click_link "Camisetas"
    end
    page.should_not have_content pants.name
    page.should     have_content t_shirt.name
    find("a.category_#{pants_category.id}")[:class].should_not =~ /current/
    find("a.category_#{t_shirt_category.id}")[:class].should =~ /current/

  end
end
