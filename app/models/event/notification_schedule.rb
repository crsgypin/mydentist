class Event::NotificationSchedule < ApplicationRecord
	belongs_to :clinic
	belongs_to :notification_template, class_name: "Event::NotificationTemplate", foreign_key: :notification_template_id
	has_many :notifications, dependent: :destroy
	enum category: {"回診修改掛號" => 1, "診所休假修改掛號" => 2, "醫生休假修改掛號" => 3, "回診推播" => 4}
	enum schedule_type: {"立即發送" => 1, "排程發送" => 2}
	enum status: {"尚未發送" => 0, "發送中" => 1, "已發送" => 2, "取消" => 3}
	json_format :data
	validates_presence_of :schedule_type
	after_create :check_notification_type
  accepts_nested_attributes_for :notifications

	def send_messages
		self.update(status: "發送中")
		self.notifications.each do |notification|
			notification.send_message
		end
		self.update(status: "已發送")
	end

	private

	def check_notification_type
		if self.schedule_type == "立即發送"
			send_messages
		end
	end

	# def set_notifications
	# 	if ["回診修改掛號", "診所休假修改掛號", "醫生休假修改掛號"].include?(self.category)
	# 		event_objs.each do |event_obj| 
	# 			event = self.clinic.events.find_by(id: event_obj[:id])
	# 			args = event_obj[:args]
	# 			self.notifications.build({
	# 				event: event,
	# 				line_account: event.patient.line_account,
	# 				args_json: args
	# 			})
	# 		end
	# 	elsif ["回診推播"].include?(self.category)
	# 		patient_objs.each do |patient_obj|
	# 			patient = self.clinic.patients.find_by(id: patient_obj[:id])
	# 			args = patient_obj[:args]
	# 			booking_event = patient.booking_events.create!(clinic: @clinic)
	# 			self.notifications.build({
	# 				booking_event: booking_event,
	# 				line_account: patient.line_account,
	# 				args_json: args
	# 			})
	# 		end
	# 	end
	# end

end
