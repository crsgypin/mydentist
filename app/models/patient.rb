class Patient < ApplicationRecord
	belongs_to :clinic
	has_many :events

end
