class Doctor < ApplicationRecord
	belongs_to :clinic
	has_many :doctor_durations, class_name: "Doctor::Duration"
	has_many :doctor_services, class_name: "Doctor::Service"
	has_many :doctor_vacations, class_name: "Doctor::Vacation"
	has_many :services, through: :doctor_services
	has_many :events
	has_many :event_durations, through: :events
	enum status: {"在職" => 1, "離職" => 2}
	before_validation :set_friendly_id, on: :create
	validates_presence_of :friendly_id
	validates_uniqueness_of :friendly_id
	mount_uploader :photo, PhotoUploader
	include Common::DateTimeDurationHelper

	def update_doctor_durations_note!
		self.update!(:doctor_durations_note => wday_durations_note(self.doctor_durations))
	end

	def doctor_durations_note_html
		self.doctor_durations_note.gsub("\n", "<br>")
	end

  private

  def set_friendly_id
  	if self.friendly_id.nil?
  		self.friendly_id = "d#{rand(10**8)}"
  	end
  	true
  end

end
