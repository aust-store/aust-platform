# TODO unit test
require 'integration_spec_helper'

describe AccountReceivable do
  describe ".valid?" do
    before do
      @account_receivable = Factory.build(:account_receivable)
    end

    context "valid resource" do
      specify "when all fields are valid" do
        @account_receivable.should be_valid
      end

      describe "value" do
        specify "when it's not greater than zero" do
          @account_receivable.value = "10.0"
          @account_receivable.should be_valid
        end
      end
    end

    context "invalid resource" do
      after do
        @account_receivable.should_not be_valid
      end

      describe "value" do
        specify "when it's not greater than zero" do
          @account_receivable.value = nil
        end

        specify "when it's not greater than zero" do
          @account_receivable.value = -1
        end
      end

      specify "when no admin user is given" do
        @account_receivable.admin_user_id = nil
      end
    end
  end
end

