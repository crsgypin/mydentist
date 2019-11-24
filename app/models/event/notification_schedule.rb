class Event::NotificationSchedule < ApplicationRecord
	belongs_to :clinic
	belongs_to :notification_template	
	has_many :notifications
	enum category: {"回診修改掛號" => 1, "診所休假修改掛號" => 2, "醫生休假修改掛號" => 3, "回診推播" => 4}
	enum schedule_type: {"立即發送" => 1, "排程發送" => 2}
	enum status: {"尚未發送" => 0, "發送中" => 1, "已發送" => 2, "取消" => 3}
	json_format :data
	before_validation :check_status, on: :update
	befoer_create :set_notifications
	attr_accessor :event_objs
	attr_accessor :patient_objs

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

	def set_notifications
		if ["回診修改掛號", "診所休假修改掛號", "醫生休假修改掛號"].include?(self.category)
			event_objs.each do |event_obj| 
				event = self.clinic.events.find_by(id: event_obj[:id])
				args = event_obj[:args]
				self.notifications.build({
					event: event,
					line_account: event.patient.line_account,
					args_json: args
				})
			end
		elsif ["回診推播"].include?(self.category)
			patient_objs.each do |patient_obj|
				patient = self.clinic.patients.find_by(id: patient_obj[:id])
				args = patient_obj[:args]
				booking_event = patient.booking_events.create!(clinic: @clinic)
				self.notifications.build({
					booking_event: booking_event,
					line_account: patient.line_account,
					args_json: args
				})
			end
		end
	end

end
