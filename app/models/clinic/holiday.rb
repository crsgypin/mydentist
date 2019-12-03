class Clinic::Holiday < ApplicationRecord
	belongs_to :clinic

	def self.reload_clinic_holidays(clinic)
    ActiveRecord::Base.transaction do
    	clinic.clinic_holidays.destroy_all
			categories = clinic.clinic_holiday_categories
			new_holidays = Sys::Holiday.where(category: categories.map{|c| c.category})
			new_holidays.each do |holiday|
				clinic.clinic_holidays.create!({
					name: holiday.name,
					date: holiday.date,
					start_hour: holiday.start_hour,
					end_hour: holiday.end_hour
				})
			end
		end
	end

end
