class ::Clinics::Info::ClinicVacations::EventNotificationsController < ::Clinics::Info::ClinicVacations::ApplicationController

	def index
		@events = @clinic_vacation.events.where(id: params[:event_ids])
	end

	def create
		@events = @clinic_vacation.events.where(id: params[:event_ids])
		@events.each do |event|
			event.event_notifications.create!({
				line_account: event.patient.line_account,
				text_message: params[:text_message],
				category: "修改掛號"
			})
		end
	end

end
