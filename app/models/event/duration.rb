class Event::Duration < ApplicationRecord
	belongs_to :event
	before_save :check_duration

	def check_duration
		self.duration = 15 if self.duration.nil?
		true
	end

end
