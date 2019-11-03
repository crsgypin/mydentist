module ClinicDoctorVacation

	extend ActiveSupport::Concern
  included do
		validates_presence_of :start_date, :end_date
  end

	def days_count
		(self.end_date - self.start_date).to_i + 1
	end

	def events
		self.event_source.events.where("events.date >= ? and events.date <= ?", self.start_date, self.end_date)
	end

	def event_patients
		self.events.includes(:patient).map do |event|
			event.patient
		end.uniq
	end


end

