class LinebotWebhook::Controllers::EventNotificationsController < LinebotWebhook::Controllers::ApplicationController
	include LinebotWebhook::Replies::EventNotificationsReply
	def update
		@event_notification = Event::Notification.find_by(id: @message[:data][:id])
		if !@event_notification.present?
			return reply_no_event_notification
		end
		if @event_notification.status == "取消"
			return reply_has_canceled
		end
		if @event_notification.status == "同意"
			return reply_has_agreed	
		end
		if @message[:data][:status] != "取消"
			raise "錯誤"
		end
		category = @event_notification.notification_template.category
		if category == "回診推播"
			#do nothing
		elsif category == "回診修改掛號"
			#do nothing
		elsif category == "診所休假修改掛號"
			self.event.update(status: "取消")
		elsif category == "醫生休假修改掛號"
			self.event.update(status: "取消")
		end
		@event_notification.update(status: "取消")
		reply_event_cancel
	end

end


