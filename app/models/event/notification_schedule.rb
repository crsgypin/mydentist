class Event::NotificationSchedule < ApplicationRecord
	belongs_to :clinic
	belongs_to :notification_template	
	has_many :notifications
	enum schedule_type: {"立即發送" => 1, "排程發送" => 2}
	enum status: {"尚未發送" => 0, "發送中" => 1, "已發送" => 2, "取消" => 3}
	json_format :data
	before_validation :check_status

	private

	def check_status
		if self.changes[:status].present?
			if self.status == "發送中"
				self.notifications.each do |notification|
					notification.send_message
				end
				self.update(status: "已發送")
			end
		end
	end

end
