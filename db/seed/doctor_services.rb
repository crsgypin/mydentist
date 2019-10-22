
def doctor_services
	#doctor duration
	id = 1
	Doctor.includes(:clinic).each_with_index do |doctor, index|
		doctor.doctor_services.destroy_all
		service_indexes = [
			[0,1,2,3],
			[0,1,2,3,5],
			[0,1,2,4,5,6],
			[0,1,2,4,6],
			[0,1,2,3,4]
		][index%5]

		services = doctor.clinic.services
		service_indexes.map do |index|
			[services[index], index < 3 ? 15 : 30]
		end.each do |s|
			service = s[0]
			duration = s[1]
			doctor.doctor_services.create(service: service, duration: duration)
		end
	end
	puts "doctor_services done!"
	Doctor.all.each do |doctor|
		puts "#{doctor.id}'s doctor_services_count: #{doctor.doctor_services.count}"
	end
end

doctor_services
