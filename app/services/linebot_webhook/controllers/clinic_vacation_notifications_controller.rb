class LinebotWebhook::Controllers::ClinicVacationNotificationsController < LinebotWebhook::Controllers::ApplicationController
	include LinebotWebhook::Replies::ClinicVacationNotificationsReply

	def confirm_abort
		@notification = Clinic::VacationNotification.find(@message[:data][:id])
		@event = @notification.event
		reply_confirm_abort
	end

	def confirm_change
		@notification = Clinic::VacationNotification.find(@message[:data][:id])
		@event = @notification.event
		reply_confirm_change
	end

end

