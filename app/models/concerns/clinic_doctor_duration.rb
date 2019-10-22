module ClinicDoctorDuration
	include Common::DateTimeDurationHelper

	def wday_hour_minute=(str)
		r = parse_wday_hour_minute_format(str)
		self.wday = r[:wday]
		self.hour = r[:hour]
		self.minute = r[:minute]
	end

	def wday_hour_minute
		wday_hour_minute_format(self.wday, self.hour, self.minute)
	end

	def hour_minute
		hour_minute_format(self.hour, self.minute)
	end

	def end_hour
		if self.minute + self.duration >= 60
			self.hour + 1
		else
			self.hour
		end
	end

	def end_minute
		minutes = self.minute + self.duration
		if minutes >= 60
			minutes -= 60
		end
		minutes
	end

	def end_hour_minute
		hour_minute_format(self.end_hour, self.end_minute)
	end

end



