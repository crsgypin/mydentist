class Patient < ApplicationRecord
	belongs_to :clinic
	has_many :events
  has_one :line_account, class_name: "Line::Account"
  has_many :clinic_patient_notifications, class_name: "Clinic::PatientNotification"
  has_many :patient_notification_clinics, through: :clinic_patient_notifications, source: :clinic
  belongs_to :default_doctor, class_name: "::Doctor", foreign_key: :default_doctor_id, optional: true
  belongs_to :current_event, class_name: "::Event", foreign_key: :current_event_id, optional: true
  belongs_to :tooth_cleaning_service, class_name: "::Service", foreign_key: :tooth_cleaning_service_id, optional: true
  enum source: {"網路" => 1, "現場" => 2}
  enum :gender => {"男" => 1, "女" => 2}
  enum notification_list: {"無" => 0, "回診推播" => 1}
	before_validation :set_friendly_id, on: :create
  before_validation :set_birthday
  before_validation :check_for_source, on: :create
	validates_presence_of :friendly_id
	validates_uniqueness_of :friendly_id
  attr_accessor :year, :month, :day

  def filled_in_web
    self.name.present? && self.birthday.present? && self.person_id.present?
  end

  private

  def set_birthday
    if self.year.present? && self.month.present? && self.day.present?
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
      if !self.name.present?           
        self.errors.add("請填寫名稱","")
        return false
      end
      if !self.birthday.present?
        self.errors.add("請填寫生日","")
        return false
      end
      if self.person_id.nil?
        self.errors.add("請填寫身份證號碼","")
        return false
      end
    end
    true
  end

end
