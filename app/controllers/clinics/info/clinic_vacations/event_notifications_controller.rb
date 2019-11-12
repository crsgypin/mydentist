class ::Clinics::Info::ClinicVacations::EventNotificationsController < ::Clinics::Info::ClinicVacations::ApplicationController

	def index
		@events = @clinic_vacation.events.where(id: params[:event_ids])
	end

	def create
		@events = @clinic_vacation.events
		@events.each do |event|
			n = @clinic_vacation.event_notifications.create({
				event: event
			})
			if n.errors.present?
				@event_notifications[:fail] << n
			else
				@event_notifications[:pass] << n
			end
		end
	end

end
