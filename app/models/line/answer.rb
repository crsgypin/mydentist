class Line::Answer < ApplicationRecord
	belongs_to :question
	enum category: {text: 1, image: 2}
	validates_presence_of :category

end
