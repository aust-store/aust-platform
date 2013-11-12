require 'spec_helper'

feature "Deleting a customer" do
  let(:customer) do
    FactoryGirl.create(:customer,
                       first_name: "Freddie",
                       last_name: "Mercury",
                       store: @company)
  end

  background do
    login_into_admin
    customer
  end

  describe "Delete a customer" do
    scenario "As an admin, I'd like to delete a customer" do
      visit admin_customers_path
      click_link customer.first_name
      page.should have_content customer.first_name
      click_link "Excluir"

      page.should have_content I18n.t('admin.customers.notice.delete')
      current_path.should == admin_customers_path
      page.should_not have_content("Freddie Mercury")
    end
  end
end
