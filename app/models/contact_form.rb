class ContactForm < MailForm::Base
  attribute :name, validate: true
  attribute :email
  attribute :message

  validates_format_of :email, :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  validates_presence_of :name, :email, :message

  def initialize(options = {})
    @to = options[:to]
    super(options)
  end

  def headers
    { subject:  "Formulário de contato",
      to:       @to,
      reply_to: "#{name} <#{email}>",
      from:     Store::Application.config.mailer_from_address }
  end
end
