class Admin::ReceivablePresenter < Presenter
  subjects :receivable
  expose :description, :value, :due_to, :paid
  expose :created_at

  include ::ActionView::Helpers::NumberHelper

  def value
    to_currency @receivable.value
  end

  def due_to
    @receivable.due_to.strftime("%d/%m/%Y") 
  end

  def status
    if @receivable.paid?
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
