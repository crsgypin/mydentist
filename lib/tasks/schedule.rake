

namespace :schedule do
	task :check_event_status => :environment do
		r = Event.check_event_status
		Sys::Log.create({name: "爽約確認", note: r})
	end

end
