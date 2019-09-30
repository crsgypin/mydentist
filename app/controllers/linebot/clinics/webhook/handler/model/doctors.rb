module Linebot::Clinics::Webhook::Handler::Model::Doctors
	
	def doctors_index
		@doctors = @clinic.doctors
		reply_message({
			type: "text",
			text: @doctors.map do |d|
				r = []
				r << "名稱: #{d.name}"
				r << "主治: #{d.pro}"
				r.join("\n")
			end.join("\n")
		})		
	end

end
