
def event_durations
	puts "start events"
	id = 1
	Clinic.all.each do |clinic|
		clinic.events.destroy_all
		patients = clinic.patients
		services = clinic.services
		dates = (-10..10).map{|a| Date.today + a.day}

		dates.each do |date|
			clinic.doctors.each do |doctor|
				doctor_durations = doctor.doctor_durations.where(wday: date.wday)
				doctor_durations.sample(rand(30) + 10).each do |doctor_duration|
					patient = patients[rand(100)%patients.length]
					service = services[rand(100)%services.length]
					event = clinic.events.new({
						id: id,
						doctor: doctor, 
						patient: patient, 
						service: service, 
						date: date,
						hour: doctor_duration.hour,
						minute: doctor_duration.minute
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
