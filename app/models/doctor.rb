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
	include Common::StaticImageHelper
	include Clinic::StaticImageHelper

	def update_doctor_durations_note!
		self.update!(:doctor_durations_note => wday_durations_note(self.doctor_durations))
	end

	def doctor_durations_note_html
		self.doctor_durations_note.gsub("\r\n","<br>").gsub("\n", "<br>")
	end

	def photo_url
		if self.photo.present?
			self.photo.url
		else
			"#{Rails.application.config_for(:api_key)["base_domain"]}#{clinic_static_image_url(:doctor)}"
		end
	end

	def pro
		self[:pro].present? ? self[:pro] : "(建置中)"
	end

	def title_name
		"#{self.name}#{self.title}"
	end

	def has_vacation?(date)
		date_vacation = self.doctor_vacations.find_by("start_date <= ? and end_date >= ?", date, date)		
		date_vacation.present?
	end

	def day_events(date)
		events = self.events.where(date: date).includes(:patient, :doctor, :service, :event_durations)
	end

	def day_hour_minute_events(date, hours = nil, options = {})
		event_id = options[:event_id] #show event_id only

		events = day_events(date)
		if hours.nil?
			hours = segment_hours("整日")
		end
		has_vacation = self.has_vacation?(date)

		hour_minutes = hours.map do |hour|
			(60 / Clinic.default_duration).times.map do |index|
				minute = Clinic.default_duration * index
				{hour: hour, minute: minute}
			end
		end.flatten

		hour_minutes.map do |hour_minute|
			hour = hour_minute[:hour]
			minute = hour_minute[:minute]
			time = Time.parse("#{date.strftime('%Y/%m/%d')} #{hour}:#{"%02d"%minute}")
			es = events.select do |event|
 				r = event.event_durations.find do |event_duration|
	 				event_duration.hour == hour && event_duration.minute == minute
 				end
 				if r && event_id.present?
 					r = (event.id == event_id.to_i)
 				end
 				r
 			end
			r = {
				date: date,
			 	hour: hour,
			 	minute: minute,
			 	time: time,
			 	expired: Time.now > time,
	 			has_vacation: has_vacation,
	 			events: es
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
