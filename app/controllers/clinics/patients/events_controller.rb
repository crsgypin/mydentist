class ::Clinics::Patients::EventsController < ::Clinics::Patients::ApplicationController

	def index
		@events = @patient.events.includes(:service, :doctor).order(:date, :hour, :minute)
	end

end

