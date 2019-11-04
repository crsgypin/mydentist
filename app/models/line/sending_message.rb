class Line::SendingMessage < ApplicationRecord
	self.table_name = "line_sending_messages"
	belongs_to :sending
	enum message_type: {
		text: 1, image: 2, video: 3, template: 4, #server side
		follow: 21, unfollow: 22, message: 23, postback: 24 #client side
	}
	enum template_type: {carousel: 1, confirm: 2, buttons: 3}
	json_format :content
	before_validation :check_message_type, on: :create

	def check_message_type
		data = self.content_json
		begin
		self.message_type = data[:type]
		if self.message_type == "template"
			self.template_type = data[:template][:type]
		end
		rescue
			# do nothing
		end
	end

end
