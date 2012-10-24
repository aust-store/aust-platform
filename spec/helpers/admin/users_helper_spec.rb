require './app/helpers/admin/users_helper'

class DummyUsersHelper
  include Admin::UsersHelper
end

describe Admin::UsersHelper do
  subject { DummyUsersHelper.new }
  before do
    @user1 = double(id: 1)
    @user2 = double(id: 2)
  end
  
  describe "#can_edit_users?" do
    it "returns true when the user's role is founder" do
      subject.stub(:can?) { true }
      subject.can_edit_users?(@user1, @user2).should == true
    end

    it "returns false when the user's role is not founder" do
      subject.stub(:can?) { false }
      subject.can_edit_users?(@user1, @user2).should == false
    end

    it "returns true when the user is itself" do
      subject.stub(:can?) { false }
      subject.can_edit_users?(@user1, @user1).should == true
    end
  end

  describe "#can_destroy_users?" do
    it "returns true when the user's role is founder" do
      subject.stub(:can?) { true }
      subject.can_destroy_users?(@user1, @user2).should == true
   end

    it "returns false when the user's role is not founder" do
      subject.stub(:can?) { false }
      subject.can_destroy_users?(@user1, @user2).should == false
   end

    it "returns false when a founder is trying to erase itself" do
      subject.stub(:can?) { true }
      subject.can_destroy_users?(@user1, @user1).should == false
    end

    it "returns false when a collaborator is trying to erase itself" do
      subject.stub(:can?) { false }
      subject.can_destroy_users?(@user1, @user1).should == false
    end
  end

  describe "#is_same_user?" do
    it "returns true when the users are the same" do
      subject.is_same_user?(@user1, @user1).should == true
    end

    it "returns false when the users are not the same" do
      subject.is_same_user?(@user1, @user2).should == false
    end
  end
end