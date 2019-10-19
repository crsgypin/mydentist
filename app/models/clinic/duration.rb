class Clinic::Duration < ApplicationRecord
	belongs_to :clinic
	before_create :set_duration
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

	private

	def set_duration
		self.duration = 15
	end

end
