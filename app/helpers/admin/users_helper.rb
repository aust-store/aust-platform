module Admin::UsersHelper
  def roles_for_select
    result = [["Colaborador", "collaborator"]]
    enabled_pos = Store::Policy::PointOfSale.new(@current_company).enabled?
    result << ["Ponto de venda", "point_of_sale"] if enabled_pos
    result
  end

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
