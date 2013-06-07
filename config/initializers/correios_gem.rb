# https://github.com/prodis/correios-frete
Correios::Frete.configure do |config|
  config.log_enabled = false
  config.log_level = :debug
  config.logger = Rails.logger
end
