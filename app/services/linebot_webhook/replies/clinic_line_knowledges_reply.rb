module LinebotWebhook::Replies::ClinicLineKnowledgesReply

	def reply_clinic_line_knowledge
		@clinic_line_knowledge.line_template.template_messages.map do |m|
			if m.category == "text"
				reply_message({
					type: "text",
					text: m.content
				})
			elsif m.category == "image"
				reply_message({
					type: "image",
					previewImageUrl: m.file.url,
					originalContentUrl: m.file.url
				})
			end
		end
	end

end



