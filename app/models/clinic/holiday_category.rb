class Clinic::HolidayCategory < ApplicationRecord
	belongs_to :clinic
	include HolidayCategoriesConcern

end
