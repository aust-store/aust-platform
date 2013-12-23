# See config/initializers/teaspoon.rb for monkey patch

ENV["RAILS_ROOT"] = File.expand_path("../../", __FILE__)
require File.expand_path("../../config/environment", __FILE__)

# Provide default configuration.
#
# You can override various configuration directives defined here by using arguments with the teaspoon command.
#
# teaspoon --driver=selenium --suppress-log
# rake teaspoon DRIVER=selenium SUPPRESS_LOG=false
Teaspoon.setup do |config|
  # Driver / Server
  config.driver           = "phantomjs" # available: phantomjs, selenium
  #config.server           = nil # defaults to Rack::Server

  # Behaviors
  #config.server_timeout   = 20 # timeout for starting the server
  #config.server_port      = nil # defaults to any open port unless specified
  #config.fail_fast        = true # abort after the first failing suite

  # Output
  #config.formatters       = "dot" # available: dot, tap, tap_y, swayze_or_oprah
  #config.suppress_log     = false # suppress logs coming from console[log/error/debug]
  #config.color            = true

  # Coverage (requires istanbul -- https://github.com/gotwarlost/istanbul)
  #config.coverage         = true
  #config.coverage_reports = "text,html,cobertura"
end
