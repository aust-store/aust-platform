class Good::Balance < ActiveRecord::Base
  belongs_to :good
  belongs_to :admin_user

  attr_accessible :good_id, :description, :quantity, :cost_per_unit, :good

  accepts_nested_attributes_for :good

  before_save :define_new_balance_values

  def define_new_balance_values
    past_balances = Good::Balance.where(good_id: good_id).where("quantity > 0").all
    balance = Store::DomainObject::Balance.new([self] + past_balances)

    self.total_quantity      = balance.total_quantity
    self.total_cost          = balance.total_cost
    self.moving_average_cost = balance.moving_average_cost
  end
end
