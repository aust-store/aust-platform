module Admin
  class AccountReceivableDecorator < ApplicationDecorator
    decorates :account_receivable
    decorates :customer

    include ::ActionView::Helpers::NumberHelper

    def value
      to_currency(model.value)
    end

    def due_to
      unless model.due_to.nil?
        model.due_to.strftime("%d/%m/%Y")
      end
    end

    def status
      if model.paid?
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
end
