module LinebotWebhook::Handler::Model::Clinics

	def clinic_show
		reply_message({
			type: "text",
			text: [
				"名稱: #{@clinic.name}",
				"電話: #{@clinic.phone}",
				"地址: #{@clinic.address}",
				"描述: #{@clinic.description}"
			].join("\n")
		})		
	end

end

