
namespace :schedule do
	task :check_event_status => :environment do
		r = Event.check_event_status
		Sys::Log.create({name: "爽約確認", note: r})
	end

	task :check_event_notification_schedule => :environment do
		t = Time.now
		if t.hour >= 6 && t.hour < 24
			r = {pass: 0, fail: 0}
			Event::NotificationSchedule.where(schedule_type: "排程發送", status: "推播中").each do |s|
				k = s.update(trigger_schedule: 1)
				if k
					r[:pass] += 1
				else
					r[:fail] += 1
				end
			end
			n = "pass: #{r[:pass]}, fail: #{r[:fail]}"
			Sys::Log.create({name: "掛號推播中", note: n})
		end
	end

end
