 class ::Clinics::Lightbox::ClinicNotificationsController < ::Clinics::ApplicationController

	def index
		@clinic_notifications = @clinic.clinic_notifications.order(id: :desc).first(40)
	end

	private

end

