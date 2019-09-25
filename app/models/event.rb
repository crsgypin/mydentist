class Event < ApplicationRecord
	belongs_to :clinic
	belongs_to :line_account, class_name: "Line::Account"
	belongs_to :patient, optional: true
	belongs_to :doctor, optional: true

end
