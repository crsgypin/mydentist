class Knowledge < ApplicationRecord
	belongs_to :knowledge_category
	has_many :line_questions, class_name: "Line::Question", as: :questionable

end
