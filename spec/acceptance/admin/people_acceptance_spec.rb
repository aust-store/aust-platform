require 'spec_helper'

feature "Admin/People" do
  let(:person) { create(:person, store: @company) }

  background do
    login_into_admin
  end

  scenario "As admin, I can see the person's details" do
    person = nil

    Timecop.travel(Time.utc(2013, 8, 9, 10, 10, 10)) do
      person = create(:person, store: @company)
    end

    Timecop.travel(Time.utc(2013, 8, 8, 10, 10, 10)) do
      visit admin_person_path(person)

      page.should have_content person.first_name
      page.should have_content person.last_name
      page.should have_content person.email
      page.should have_content person.social_security_number
      page.should have_content "#{person.home_area_number} #{person.home_number}"
      page.should have_content "1 dia atrás"
    end
  end

  describe "creating a person" do
    scenario "As an admin, I create a person" do
      Person.count.should == 0

      visit admin_people_path
      page.should_not have_content "Freddie"
      click_on "add_item"

      fill_in "person_email",                               with: "sherlock@holmes.com"
      fill_in "person_first_name",                          with: "Freddie"
      fill_in "person_last_name",                           with: "Mercury"
      fill_in "person_password",                            with: "guess_my_password"
      fill_in "person_password_confirmation",               with: "guess_my_password"
      fill_in "person_social_security_number",              with: "141.482.543-93"
      fill_in_phones
      fill_in_address
      click_button "submit"

      current_path.should == admin_people_path
      page.should have_content "Freddie Mercury"
      Person.last.environment.should == "admin"
    end
  end

  describe "editing a person" do
    before do
      person
    end

    scenario "As an admin, I update a persons" do
      visit admin_people_path
      click_link person.first_name
      click_link "Editar"

      current_path.should == edit_admin_person_path(person)
      find("#person_receive_newsletter").value.should === "1"
      fill_in "person_first_name", with: "Freddie"
      fill_in "person_last_name", with: "Mercury"
      click_button "submit"

      current_path.should == admin_person_path(person)
      page.should have_content "Freddie"
      page.should have_content "Mercury"
    end
  end

  describe "deleting a person" do
    before do
      person
    end

    scenario "As an admin, I want to like to delete a person" do
      person.enabled.should == true
      visit admin_people_path

      page.should have_content person.first_name
      page.should have_content person.last_name

      click_link person.first_name
      click_link "Desativar"

      page.should have_content I18n.t('admin.default_messages.delete.success')
      current_path.should == admin_people_path
      person.reload.enabled.should == false
    end
  end

  def fill_in_address
    fill_in "person_addresses_attributes_0_address_1",    with: "Baker street"
    fill_in "person_addresses_attributes_0_number",       with: "221B"
    fill_in "person_addresses_attributes_0_address_2",    with: "I don't know"
    fill_in "person_addresses_attributes_0_neighborhood", with: "Central London"
    fill_in "person_addresses_attributes_0_zipcode",      with: "96360000"
    fill_in "person_addresses_attributes_0_city",         with: "London"
    select "Rio Grande do Sul", from: "person_addresses_attributes_0_state"
  end

  def fill_in_phones
    fill_in "person_home_number",                         with: "1234-1234"
    fill_in "person_home_area_number",                    with: "53"
    fill_in "person_mobile_number",                       with: "1234-1234"
    fill_in "person_mobile_area_number",                  with: "53"
  end
end
