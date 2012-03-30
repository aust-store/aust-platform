# Runs spec_no_rails/ specs
Dir[Rails.root.join("spec_no_rails/**/*.rb")].each { |f| require f }
