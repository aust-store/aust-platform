require "cancan/matchers"
require "spec_helper"

describe AdminUser do
  describe "abilities" do
    subject { ability }

    context "As a founder" do
      let(:ability) { Ability.new(admin_user) }
      let(:admin_user){ FactoryGirl.build(:admin_user, id: 1) }

      it "should be able to manage users" do
        should be_able_to(:manage, AdminUser.new)
      end

      it "should not be able to destroy itself" do
        should_not be_able_to(:destroy, admin_user)
      end
    end

    context "As a collaborator" do
      let(:ability) { Ability.new(collaborator) }
      let(:collaborator){ FactoryGirl.build(:admin_user, id: 1, role: "collaborator") }

      it "should be able to read users" do
        should be_able_to(:read, AdminUser.new)
      end

      it "should be able to update itself" do
        should be_able_to(:update, collaborator)
      end

      it "should not be able to edit others" do
        should_not be_able_to(:update, AdminUser.new)
      end

      it "should not be able to destroy itself " do
        should_not be_able_to(:destroy, collaborator)
      end

      it "should not be able to destroy others" do
        should_not be_able_to(:destroy, AdminUser.new)
      end
    end
  end
end