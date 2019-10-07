
def clinic_durations
	id = 1
	Clinic.all.each_with_index do |clinic, index|
		puts "clinic_durations: #{clinic.id}"
		clinic.clinic_durations.destroy_all

		wdays = [
			{
				1 => (9..21),
				2 => (9..21),
				3 => (9..11),
				4 => (9..21),
				5 => (9..21),
				6 => (9..21)
			},
			{
				0 => (9..11),
				1 => (9..21),
				2 => (9..21),
				3 => (15..21),
				4 => (9..21),
				5 => (9..21),
			},
		][index]

		wdays.each do |wday, hs|
			hs.each do |hour|
				if [9,10,11,14,15,16,17,18,19,20,21].include?(hour)
					[0, 15, 30, 45].each do |minute|
						clinic_duration = clinic.clinic_durations.find_or_initialize_by(wday: wday, hour: hour, minute: minute)

						clinic_duration.id = id
						clinic_duration.save!
						id += 1
					end
				end
			end
		end
	end
	puts "clinic_durations done!!"
	Clinic.all.each do |clinic|
		puts "#{clinic.id}'s clinic_durations_count: #{clinic.clinic_durations.count}"
	end

end

clinic_durations
