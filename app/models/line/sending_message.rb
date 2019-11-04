class Line::SendingMessage < ApplicationRecord
	belongs_to :sending
	enum message_type: {"text" => 1, "image" => 2, "video" => 3, "template_confirm" => 11, "template_buttons" => 12, "template_carousel" => 13}
	json_format :content
	before_validation :check_message_type, on: :create

	def check_message_type
		data = self.content_json
		if data[:type] == "text"
			self.message_type = "text"
		elsif data[:type] == "image"
			self.message_type = "image"
		elsif data[:type] == "video"
			self.message_type = "video"
		elsif data[:type] == "template"
			if data[:template][:type] == "carousel"
				self.message_type = "template_carousel"
			elsif data[:template][:type] == "confirm"
				self.message_type = "template_confirm"
			elsif data[:template][:type] == "buttons"
				self.message_type = "template_buttons"
			end
		end
	end

end
