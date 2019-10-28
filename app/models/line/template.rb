class Line::Template < ApplicationRecord
	self.table_name = "line_templates"
	belongs_to :templateable, polymorphic: true
	has_many :keywords, class_name: "Line::Keyword", dependent: :destroy
	has_many :template_messages, class_name: "Line::TemplateMessage", dependent: :destroy

	def title
		self.keyword_names.join(",")
	end

	def keyword_names=(keywords)
		self.keywords.destroy_all if self.id.present?
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

	def content
		self.message_contents.first
	end

	def message_contents=(contents)
		self.template_messages.destroy_all if self.id.present?
		contents.split("|").each do |content|
			k = self.template_messages.new(category: "text", content: content)
			k.save if self.id.present?
		end
	end

	def message_contents
		self.template_messages.map do |m|
			m.content
		end
	end


end
