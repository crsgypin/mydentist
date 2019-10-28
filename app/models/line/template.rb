class Line::Template < ApplicationRecord
	self.table_name = "line_templates"
	belongs_to :templateable, polymorphic: true
	has_many :keywords, class_name: "Line::Keyword", dependent: :destroy
	has_many :template_messages, class_name: "Line::TemplateMessage", dependent: :destroy

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

	def first_content
		first_content = self.content_json[0]
		first_content[:text]
	end


end
