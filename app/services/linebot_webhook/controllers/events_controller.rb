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

	#以下為掛號確認後最後確定
	def confirm_reject
		#預約完畢最後確認，按『否』
		event = @line_account.events.find_by!(id: @message[:data][:id])
		event.destroy!
		@line_account.update(dialog_status: "預約掛號")
		reply_event_confirm_reject
	end

	def confirm_ok
		#預約完成最後確認，按『是』
		event = @line_account.events.find_by!(id: @message[:data][:id])
		if event.status == "已預約"
			#do nothing
			reply_event_confirm_ok_reserved
		elsif event.status == "缺少病患資料"
			@line_account.update({
				dialog_status: "填寫個人資料",
				dialog_status_step: 1 
			})
			reply_event_confirm_ok_lack_patient
		end
	end

end

