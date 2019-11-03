class Clinic::Vacation < ApplicationRecord
	belongs_to :clinic
	validates_presence_of :start_date, :end_date

	def days_count
		(self.end_date - self.start_date).to_i + 1
	end
	

end
