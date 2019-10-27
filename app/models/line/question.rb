class Line::Question < ApplicationRecord
	belongs_to :questionable, polymorpihic: true
	
end
