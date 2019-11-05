class ::Clinics::Info::ClinicVacations::VacationNotificationsController < ::Clinics::Info::ClinicVacations::ApplicationController

	def index
		@events = @clinic_vacation.events
	end

	def create
		@events = @clinic_vacation.events.includes(:patient => :line_account)
		@vacation_notifications = {pass: [], fail: []}
		@events.each do |event|
			n = @clinic_vacation.vacation_notifications.create({
				event: event
			})
			if n.errors.present?
				@vacation_notifications[:fail] << n
			else
				@vacation_notifications[:pass] << n
			end
		end
	end

end
