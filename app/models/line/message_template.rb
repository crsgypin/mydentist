class Line::MessageTemplate < ApplicationRecord
	self.table_name = "line_message_templates"
	belongs_to :templateable, polymorphic: true
	has_many :keywords, class_name: "Line::Keyword", dependent: :destroy
	json_format :content

	def keyword_names=(keywords)
		self.keywords.destroy if self.id.present?
	  keywords.present? && keywords.split(",").each do |keyword|
	  	k = self.keywords.new(name: keyword)
	  	k.save if self.id.present?
	  end
	end

	def keyword_names
		self.keywords.map do |k|
			k.name
		end
	end

end
