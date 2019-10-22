class LinebotWebhook::Controllers::EventsController < LinebotWebhook::Controllers::ApplicationController
	include LinebotWebhook::Replies::EventsReply

	def index
		@events = @line_account.events.where(status: "已預約")
		reply_events
	end

	def destroy
		if @message[:data][:status] == "已預約"
			booking_event = @line_account.events.find_by(status: "已預約", id: @message[:data][:id])
		end
		if booking_event.present?
			booking_event.update(status: "預約中取消")
		end
		reply_event_destroyed
	end

end

