
namespace :schedule do
	task :check_event_status => :environment do
		r = Event.check_event_status
		Sys::Log.create({name: "爽約確認", note: r})
	end

	task :check_event_notification_schedule => do
		t = Time.now
		if t.hour >= 6 && t.hour < 24
			Event::NotificationSchedule.where(schedule_type: "排程發送", status: "推播中").each do |s|
				s.update(trigger_schedule: 1)
			end
			Sys::Log.create({name: "掛號推播中", note: r})
		end
	end

end
