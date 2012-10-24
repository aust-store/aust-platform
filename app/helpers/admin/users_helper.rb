module Admin::UsersHelper
  def can_edit_users?(user, current_admin_user)
    can?(:manage, user) || is_same_user?(user, current_admin_user)
  end

  def can_destroy_users?(user, current_admin_user)
    can?(:manage, user) && !is_same_user?(user, current_admin_user)
  end

  def is_same_user?(user, other_user)
    user.id == other_user.id
  end
end