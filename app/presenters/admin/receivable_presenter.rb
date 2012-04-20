class Admin::ReceivablePresenter < Presenter
  subjects :receivable
  expose :id, :description, :value, :due_to, :paid
  expose :created_at
  expose :customer
  expose :errors, :model_name, :persisted?

  include ::ActionView::Helpers::NumberHelper
  include ActiveModel::Conversion

  def value
    to_currency @receivable.value
  end

  def due_to
    @receivable.due_to.strftime("%d/%m/%Y") unless @receivable.due_to.nil? 
  end

  def status
    if @receivable.paid?
      "pago"
    else
      "pendente"
    end
  end

  def self.model_name
    ActiveModel::Name.new AccountReceivable
  end

  private

  def to_currency(value)
    number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end
end
