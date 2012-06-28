class Admin::GoodBalanceDecorator < ApplicationDecorator
  decorates :good_balance, class: ::Good::Balance
  allows :description
  allows :quantity, :cost_per_unit, :total_quantity, :total_cost
  allows :created_at

  include ::ActionView::Helpers::NumberHelper

  def cost_per_unit
    to_currency good_balance.cost_per_unit
  end

  def total_cost
    to_currency good_balance.total_cost
  end

  def created_at
    good_balance.created_at.strftime("%d/%m/%Y")   
  end

  private

  def to_currency(value)
    number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end
end
