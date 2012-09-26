[:app, :lib].each do |dir|
  full_path = File.expand_path(Dir.pwd + '/' + dir.to_s)
  $LOAD_PATH.unshift full_path unless $LOAD_PATH.include?(full_path)
end

Dir[File.expand_path("../contracts/**/*_contract.rb", __FILE__)].each do |f|
  require f
end

RSpec.configure do |config|
  config.filter_run wip: true
  config.run_all_when_everything_filtered = true
  config.alias_it_should_behave_like_to :it_obeys_the, 'it obeys the'
end
