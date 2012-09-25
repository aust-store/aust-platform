module Admin
  class AccountReceivableDecorator < ApplicationDecorator
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
      unless account_receivable.due_to.nil? 
        account_receivable.due_to.strftime("%d/%m/%Y") 
      end
    end

    def status
      if account_receivable.paid?
        "pago"
      else
        "pendente"
      end
    end

    private

    # TODO create own lib for converting currency, so we can better isolate this
    # in our tests
    def to_currency(value)
      number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
    end
  end
end
