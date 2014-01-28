require "spec_helper"

describe AdminUser do
  it { should belong_to(:company) }

  describe "validations" do
    context "roles" do
      it { should allow_value("founder").for(:role) }
      it { should allow_value("collaborator").for(:role) }
      it { should allow_value("point_of_sale").for(:role) }
      #it { should allow_value("consultant").for(:role) }
      it { should_not allow_value("admin").for(:role) }
    end

    context "when valid resource" do
      it { should validate_uniqueness_of(:name).scoped_to(:company_id) }
      it { should allow_value("a@b.com").for(:email) }
      it { should validate_uniqueness_of(:email) }
      it { should allow_value(123456).for(:password) }
    end

    context "when invalid resource" do
      it { :name.should_not be_blank }
      it { :email.should_not be_blank }
      it { should_not allow_value("blah").for(:email) }
      it { should_not allow_value("ab.com").for(:email) }
      it { :password.should_not be_blank }
      it { should_not allow_value(12345).for(:password) }
      it { :password_confirmation.should_not be_blank }
    end

    it { should allow_mass_assignment_of(:password) }
  end
end
