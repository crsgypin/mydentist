class Event::NotificationSchedule < ApplicationRecord
	belongs_to :clinic
	belongs_to :notification_template, class_name: "Event::NotificationTemplate", foreign_key: :notification_template_id
	belongs_to :event, optional: true #for 排程發送
  belongs_to :doctor, optional: true
	has_many :notifications, dependent: :destroy
	# enum category: {"回診修改掛號" => 1, "診所休假修改掛號" => 2, "醫生休假修改掛號" => 3, "回診推播" => 4}
	enum schedule_type: {"立即發送" => 1, "排程發送" => 2}
	enum status: {"尚未發送" => 0, "發送中" => 1, "已發送" => 2, 
    "推播中" => 11, "推播逾期" => 12, "已佔滿" => 13, "已取消" => 14}
	validates_presence_of :schedule_type
	after_create :check_notification_type
  accepts_nested_attributes_for :notifications
  before_create :set_message_to_template
  attr_accessor :template_message
  include Common::DateTimeDurationHelper
  include EventNotificationScheduleConcern

  def category
  	self.notification_template.category
  end

  def set_message_to_template
    self.notification_template.update(content: self.template_message) if self.template_message.present?
  end

	private

	def check_notification_type
		if self.schedule_type == "立即發送"
      self.reload #reload template message
      self.update(status: "發送中")
      self.notifications.where(status: "尚未發送").each do |notification|
        notification.send_message
      end
      self.update(status: "已發送")
    elsif self.schedule_type == "排程發送"
      #create pseudo event for broadcast
      self.create_broadcast_event
      self.save
		end
    true
	end


end
 