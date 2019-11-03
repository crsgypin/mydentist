class Doctor < ApplicationRecord
	belongs_to :clinic
	has_many :doctor_durations, class_name: "Doctor::Duration", dependent: :destroy
	has_many :doctor_services, class_name: "Doctor::Service", dependent: :destroy
	has_many :doctor_vacations, class_name: "Doctor::Vacation", dependent: :destroy
	has_many :services, through: :doctor_services
	has_many :events
	has_many :event_durations, through: :events
	enum status: {"在職" => 1, "離職" => 2}
	before_validation :set_friendly_id, on: :create
	validates_presence_of :friendly_id, :name
	validates_uniqueness_of :friendly_id
	mount_uploader :photo, PhotoUploader
	accepts_nested_attributes_for :doctor_services
	include Common::DateTimeDurationHelper

	def update_doctor_durations_note!
		self.update!(:doctor_durations_note => wday_durations_note(self.doctor_durations))
	end

	def doctor_durations_note_html
		self.doctor_durations_note.gsub("\n", "<br>")
	end

	def photo_url
		if self.photo.present?
			self.photo.url
		else
			common_static_image_url(:dentist3)
		end
	end

	def current_event_durations(date, service_duration)
		doctor_event_durations = self.event_durations.where("events.date = ?", date)
		doctor_duration_hours = self.doctor_durations.where(wday: date.wday).map do |doctor_duration|
			doctor_duration.hour
		end
		[
			{name: "上午診", hours: self.clinic.wday_segment_hours(date.wday, "早上")},
			{name: "下午診", hours: self.clinic.wday_segment_hours(date.wday, "下午")},
			{name: "晚上診", hours: self.clinic.wday_segment_hours(date.wday, "晚上")},
		].map do |segment|
			segment_durations = {
				name: segment[:name],
				hour_segments: segment[:hours].map do |hour|
					h = {
						has_duration: doctor_duration_hours.include?(hour),
						hour: hour,
						minute_segments: (60 / Clinic.default_duration).times.map do |index|
							minute = Clinic.default_duration * index
							m = {
								minute: minute,
								enabled: proc do
									enabled = true
									enabled = false if date < Date.today
									(service_duration / Clinic.default_duration).times.each do |index|
										hh = hour
										mm = minute + Clinic.default_duration * index
										if mm > 60
											hh += 1
											mm -= 60
										end
										if doctor_event_durations.find{|d| d.hour == hh && d.minute == mm}
											enabled = false
										end
									end
									enabled
								end.call
							}
						end
					}
				end
			}
		end
	end

  private

  def set_friendly_id
  	if self.friendly_id.nil?
  		self.friendly_id = "d#{rand(10**8)}"
  	end
  	true
  end

end
