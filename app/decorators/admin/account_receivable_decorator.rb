class Admin::AccountReceivableDecorator < ApplicationDecorator
  decorates :account_receivable
  decorates :customer

  allows :id, :description, :value, :due_to, :paid, :created_at
  allows :customer
  allows :errors

  include ::ActionView::Helpers::NumberHelper

  def value
    to_currency account_receivable.value
  end

  def due_to
    account_receivable.due_to.strftime("%d/%m/%Y") unless account_receivable.due_to.nil? 
  end

  def status
    if account_receivable.paid?
      "pago"
    else
      "pendente"
    end
  end

  private

  def to_currency(value)
    number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end
end
