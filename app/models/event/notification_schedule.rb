class Event::NotificationSchedule < ApplicationRecord
	belongs_to :clinic
	belongs_to :notification_template, class_name: "Event::NotificationTemplate", foreign_key: :notification_template_id
	belongs_to :event, optional: true #for 排程發送
	has_many :notifications, dependent: :destroy
	# enum category: {"回診修改掛號" => 1, "診所休假修改掛號" => 2, "醫生休假修改掛號" => 3, "回診推播" => 4}
	enum schedule_type: {"立即發送" => 1, "排程發送" => 2}
	enum status: {"尚未發送" => 0, "發送中" => 1, "已發送" => 2, "取消" => 3}
	validates_presence_of :schedule_type
	after_create :check_notification_type
  after_create :check_broadcast
  accepts_nested_attributes_for :notifications

  def category
  	self.notification_template.category
  end

  def send_schedule_messages
  	if self.category == "回診推播"
  		self.clinic.patients.includes(:event_notifications, :line_account).select do |patient|
  			patient.event_notifications.length == 0 && patient.line_account.present?
  		end.each do |patient|
  			self.notifications.create({
  				notification_template: self.notification_template,
  				patient: patient,
          doctor_id: self.doctor_id,
          service_id: self.service_id,
          hour: self.hour,
          minute: self.minute,
          duration: self.duration,
  				args_json: {
  					clinic_name: self.clinic.name,
   					patient_name: patient.name
  				}
   			})
  		end
  		self.send_instant_messages
  	end
  end

	def send_instant_messages
		self.update(status: "發送中")
		self.notifications.each do |notification|
			notification.send_message
		end
		self.update(status: "已發送")
	end

	private

	def check_notification_type
		if self.schedule_type == "立即發送"
			send_instant_messages
		end
    true
	end

  def check_broadcast
    if self.schedule_type == "排程發送"
      self.event = Event.create!({
        clinic: self.clinic,
        status: "推播中",
        doctor_id: self.doctor_id,
        date: self.date,
        hour: self.hour,
        minute: self.minute,
        duration: self.duration,
        service_id: self.service_id || self.clinic.services.first.id
      })
    end
    true
  end

end
