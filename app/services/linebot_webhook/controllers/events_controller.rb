class LinebotWebhook::Controllers::EventsController < LinebotWebhook::Controllers::ApplicationController
	include LinebotWebhook::Replies::EventsReply

	def index
		@events = @line_account.events.where(status: "已預約")
		if @events.length > 0
			reply_events
		else
			reply_no_events
		end
	end

	def confirm_destroy
		@event = @line_account.events.find_by(id: @message[:data][:id])
		reply_confirm_destroy
	end

	def destroy
		if @message[:data][:status] == "已預約"
			event = @line_account.events.find_by(status: "已預約", id: @message[:data][:id])
		end
		if event.present?
			event.update(status: "取消")
		end
		reply_event_destroyed
	end

end

