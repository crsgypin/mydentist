set :output, "log/cron_log.log" #get log
env :PATH, ENV['PATH'] #get path
# rails_env = ENV['RAILS_ENV'] || :test

# set :environment, rails_env
# set :environment,  :development

every 15.minutes do
	rake "schedule:check_event_status"
end

every 30.minutes do
	rake "schedule:check_event_notification_schedule"
end

