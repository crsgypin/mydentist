class Line::Keyword < ApplicationRecord
	self.table_name = "line_keywords"	
	belongs_to :template, class_name: "Line::Template"

end
