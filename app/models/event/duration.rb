class Event::Duration < ApplicationRecord
	belongs_to :event
	validates_presence_of :duration

end
