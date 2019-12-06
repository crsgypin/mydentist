class Event::Notification < ApplicationRecord
	#修改掛號通知
	self.table_name = "event_notifications"	
	belongs_to :notification_template
  belongs_to :notification_schedule
	belongs_to :line_account, class_name: "Line::Account"
	belongs_to :event, class_name: "Event", optional: true
  belongs_to :patient, class_name: "Patient", optional: true #to-do check if remove optional
	# belongs_to :new_event, class_name: "Event", foreign_key: :new_event_id, optional: true
	belongs_to :booking_event, class_name: "BookingEvent", optional: true
	belongs_to :line_sending, class_name: "Line::Sending", optional: true
	enum status: {"尚未發送" => 0, "尚未回覆" => 1, "同意" => 2, "取消" => 3}
  before_validation :set_line_account, on: :create
  json_format :args
  after_update :check_notification
  after_create :set_event_notification
  attr_accessor :doctor_id, :service_id, :date, :hour, :minute, :duration #for booking_event
  include Common::LineShareHelper
  # after_create :send_message
	# validates_presence_of :category
	# include EventNotificationConcern 

  include LinebotWebhook::Helper::RepliedMessageHelper

  def category
    self.notification_template.category
  end

  def send_message
    #called by notification_schedule
    sending = self.line_account.sendings.create!({
      source: "server",
      server_type: "push",
      messages: reply_message({
        type: "confirm",
        alt_text: self.arg_content,
        text: proc do 
          c = self.arg_content
          puts "cc: #{c}"
          c
        end.call,
        actions: [
          {
            type: "postback",
            label: "否",
            data: {
              controller: "event_notifications",
              action: "update",
              id: self.id,
              status: "取消"
            }
          },
          {
            type: "uri",
            label: "是，預約",
            uri: proc do 
              clinic = self.notification_template.clinic
              if self.category == "回診推播"
                liff_line_event_url(clinic, self.line_account, {
                  booking_event_id: self.booking_event.id, 
                  doctor_id: self.doctor_id,
                  service_id: self.service_id,
                  date: self.date,
                  hour: self.hour,
                  minute: self.minute,
                  duration: self.duration,
                  event_notification_id: self.id, #for response
                })

               else
                liff_line_event_url(clinic, self.line_account, {
                  event_id: self.event.id, 
                  doctor_id: self.doctor_id,
                  service_id: self.service_id,
                  date: self.date,
                  hour: self.hour,
                  minute: self.minute,
                  duration: self.duration,
                  event_notification_id: self.id #for response
                })
              end
            end.call
          }
        ]
      })        
    })
    self.update!(line_sending: sending, status: "尚未回覆")
  end

  def arg_content
    @arg_content ||= self.notification_template.arg_content(self.args_json)
  end

  private

  def set_event_notification
    if self.patient
      self.patient.check_current_event_notification
    end
  end

  def set_line_account
    if self.event.present?
      self.patient = self.event.patient
      self.line_account = self.patient.line_account
    elsif self.patient.present?
      self.line_account = self.patient.line_account
      self.booking_event = self.patient.booking_events.last || self.patient.booking_events.new
      #no save due to on create
    end
    true
  end

  def check_notification
    if self.changes[:status].present?
      if !["同意", "取消"].include?(self.status)
        return true
      end
      Clinic::Notification.on_change_event_notification(self)
    end
  end

end
