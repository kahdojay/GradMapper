# set :output, "/log/cron_log.log"

# every 1.hour do
#   runner "Graduate.scrape_li"
# end

# every :reboot do
#   rake "bundle exec rake:db drop"
#   rake "bundle exec rake:db create"
#   rake "bundle exec rake:db migrate"
#   rake "bundle exec rake:db seed"
#   runner "Graduate.scrape_li"
# end