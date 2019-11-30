class Line::TemplateMessage < ApplicationRecord
	self.table_name = "line_template_messages"
	belongs_to :template, class_name: "Line::Template"
	enum category: {text: 1, image: 2}
	mount_uploader :file, FileUploader

	def self.category_names
		r = {
			"text" => "文字",
			"image" => "圖片"
		}
	end

end
