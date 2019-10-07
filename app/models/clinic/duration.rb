class Clinic::Duration < ApplicationRecord
	belongs_to :clinic
	before_create :set_duration

	private

	def set_duration
		self.duration = 15
	end

end
