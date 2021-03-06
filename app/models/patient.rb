class Patient < ApplicationRecord
	belongs_to :clinic
	has_many :events, dependent: :destroy
  has_many :booking_events
  has_one :line_account, class_name: "Line::Account"
  has_one :clinic_patient_notification, class_name: "Clinic::PatientNotification", dependent: :destroy
  has_many :event_notifications, class_name: "Event::Notification"
  # has_one :event_notification, -> { order(id: :desc)}, class_name: "Event::Notification"
  belongs_to :current_event_notification, class_name: "Event::Notification", foreign_key: :current_event_notification_id, optional: true
  belongs_to :default_doctor, class_name: "::Doctor", foreign_key: :default_doctor_id, optional: true
  belongs_to :current_event, class_name: "::Event", foreign_key: :current_event_id, optional: true
  belongs_to :last_tooth_cleaning_event, class_name: "::Event", foreign_key: :last_tooth_cleaning_event_id, optional: true
  enum source: {"網路" => 1, "現場" => 2}
  enum gender: {"男" => 1, "女" => 2}
  enum health_insurance_status: {"有" => 1, "無" => 2}
	before_validation :set_friendly_id, on: :create
  before_validation :set_birthday
  before_validation :check_for_source, on: :create
  before_validation :check_for_source_on_update, on: :update
	validates_presence_of :friendly_id
	validates_uniqueness_of :friendly_id
  attr_accessor :roc_year, :year, :month, :day, :tmp_source

  def has_line_account?
    self.line_account.present?
  end

  def filled_in_web
    self.name.present? && self.birthday.present? && self.phone.present?
  end

  def available_for_tooth_cleaning
    if self.last_tooth_cleaning_event.present?
      (Date.today - self.last_tooth_cleaning_event.date).to_i > 180
    else
      false
    end
  end

  def update_current_event
    events = self.events.where(status: "已預約")
    if events.length > 0
      self.current_event = self.events.order(date: :asc).first
    else
      self.current_event = nil
    end
    self.save
  end

  def update_last_tooth_cleaning_event
    events = self.events.joins(:service).where(status: "報到").where("services.category = ?", Service.categories["洗牙"])
    if events.length > 0
      self.last_tooth_cleaning_event = self.events.order(date: :asc).last
    else
      self.last_tooth_cleaning_event = nil
    end
    self.save
  end

  def check_current_event_notification
    if self.event_notifications.length > 0
      self.current_event_notification = self.event_notifications.last
      self.save
    end
    true
  end

  private

  def set_birthday
    if self.roc_year.present? && self.month.present? && self.day.present?
      self.birthday = Date.parse("#{self.roc_year.to_i + 1911}/#{self.month}/#{self.day}") rescue nil
    elsif self.year.present? && self.month.present? && self.day.present?
      self.birthday = Date.parse("#{self.year}/#{self.month}/#{self.day}") rescue nil
    end
  end

  def set_friendly_id
  	if self.friendly_id.nil?
  		self.friendly_id = "p#{rand(10**8)}"
  	end
  	true
  end

  def check_for_source
    if self.source == "現場"
      check_for_validation
    end
    if self.errors.present?
      return false
    end
    true
  end

  def check_for_source_on_update
    if self.tmp_source == "現場"
      check_for_validation
    end
    if self.errors.present?
      return false
    end
    true
  end

  def check_for_validation
    if !self.name.present?           
      self.errors.add("name", "請填寫名稱")
    end
    if !self.gender.present?
      self.errors.add("gender", "請填寫性別")
    end
    if !self.birthday.present?
      self.errors.add("birthday", "請填寫生日")
    end
    if !self.person_id.present?
      self.errors.add("person_id", "請填寫身份證號碼")
    end
    if !self.phone.present?
      self.errors.add("phone", "請填寫電話")
    end
    if !self.health_insurance_status.present?
      self.errors.add("health_insurance_status", "健保未填寫")
    end
  end

end
