
def event_durations
	include Common::DateTimeDurationHelper
	puts "start events"
	id = 1
	Event.where(clinic_id: Clinic.first(2).pluck(:id)).destroy_all
	Clinic.all.each do |clinic|
		patients = clinic.patients
		services = clinic.services
		dates = (-30..30).map{|a| Date.today + a.day}

		dates.each do |date|
			clinic.doctors.each do |doctor|
				doctor_durations = doctor.doctor_durations.where(wday: date.wday)
				doctor_durations.sample(rand(20) + 5).each do |doctor_duration|
					patient = patients[rand(100)%patients.length]
					service = services[rand(100)%services.length]
					hour = doctor_duration.hour
					minute = doctor_duration.minute
					duration = service.duration
					event = clinic.events.new({
						id: id,
						doctor: doctor, 
						patient: patient, 
						service: service, 
						date: date,
						hour: hour,
						minute: minute,
						duration: duration,
						source: rand(10) > 4 ? "現場" : "網路",
						status: proc do
							if date < Date.today
								rand(10) > 5 ? "爽約" : "報到"
							else
								"已預約"
							end
						end.call
					})
					event.save!
					id += 1
				end
				puts "clinic: #{clinic.id}, date: #{date}, doctor: #{doctor.id}, events: #{doctor.events.where(date: date).count}"
			end
		end
	end
	puts "events done!!"
end

event_durations
