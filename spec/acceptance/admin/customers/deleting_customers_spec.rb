require 'spec_helper'

feature "Deleting a customer" do

  background { login_into_admin }

  let!(:customer) do
    FactoryGirl.create( :customer,
                        first_name: "Freddie",
                        last_name: "Mercury",
                        company: @company)
  end

  describe "Delete a customer" do
    scenario "As an admin, I'd like to delete a customer" do
      visit admin_customers_path
      click_link customer.name
      page.should have_content customer.name
      click_link "Excluir"

      page.should have_content I18n.t('admin.customers.notice.delete')
      current_path.should == admin_customers_path
      page.should_not have_content("Freddie Mercury")
    end
  end
end
