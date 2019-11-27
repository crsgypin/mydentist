module ServiceDurationsConcern

	def init_durations
		d = {"依情況而定" => nil}
		t = 6.times.map do |hour|
			[15, 30, 45, 60].map do |minute|
				{hour: hour, minute: minute}
			end
		end.flatten.map do |t|			
			hour = t[:hour]
			minute = t[:minute]
			if minute == 60
				hour +=1
				minute = 0
			end
			t = 60 * hour
			r = ""
			if hour > 0
				r += "#{hour}小時"
			end
			if minute > 0
				t += minute
				r += "#{minute}分鐘"
			end
			[r, t]
		end.to_h
		d.merge(t)
	end	

end

