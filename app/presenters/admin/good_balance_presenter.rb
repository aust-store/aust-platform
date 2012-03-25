class Admin::GoodBalancePresenter < Presenter
  subjects :balance
  expose :description
  expose :quantity, :cost_per_unit, :total_quantity, :total_cost
  expose :created_at

  include ::ActionView::Helpers::NumberHelper

  def cost_per_unit
    to_currency @balance.cost_per_unit
  end

  def total_cost
    to_currency @balance.total_cost
  end

  def created_at
    @balance.created_at.strftime("%d/%m/%Y")   
  end

  private

  def to_currency(value)
    number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end
end
