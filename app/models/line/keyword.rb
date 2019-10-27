class Line::Keyword < ApplicationRecord
	belongs_to :keywordable, polymorpihic: true
	belongs_to :message_template, class_name: "Line::MessageTemplate"

end
