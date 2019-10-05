
def doctor_durations
	#doctor duration
	id = 1
	Doctor.includes(:clinic).each_with_index do |doctor, index|
		puts "doctor_duration: #{doctor.id}"
		doctor.doctor_durations.destroy_all
		wdays = [
			[0,1,2,3,5],
			[2,3,4,5,6],
			[0,1,4,6]
		][index%3]

		wdays.each do |wday|
			doctor.clinic.clinic_durations.where(wday: wday).each do |clinic_duration|
				doctor_duration = doctor.doctor_durations.find_or_initialize_by(wday: wday, hour: clinic_duration.hour, minute: clinic_duration.minute)
				doctor_duration.id = id
				doctor_duration.save!
				id += 1
			end
		end
	end
	puts "doctor_durations done!!"
end

