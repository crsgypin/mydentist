class Line::MessageTemplate < ApplicationRecord
	belongs_to :templateable, polymorpihic: true
	json_format :content_json

end
