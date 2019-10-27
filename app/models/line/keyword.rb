class Line::Keyword < ApplicationRecord
	self.table_name = "line_keywords"	
	belongs_to :message_template, class_name: "Line::MessageTemplate"

end
