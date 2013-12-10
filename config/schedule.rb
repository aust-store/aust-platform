# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "log/cron.log"

every 1.day, at: '01:00' do
  rake "backup:uploads"
  rake "backup:themes"
end
