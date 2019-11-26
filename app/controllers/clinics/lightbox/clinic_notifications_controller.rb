 class ::Clinics::Lightbox::ClinicNotificationsController < ::Clinics::ApplicationController

	def index
		@clinic_notifications = @clinic.clinic_notifications.last(40)
	end

	private

end

