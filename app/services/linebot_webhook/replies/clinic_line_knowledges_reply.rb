module LinebotWebhook::Replies::ClinicLineKnowledgesReply

	def reply_clinic_line_knowledge
		@clinic_line_knowledge.line_template.template_messages.map do |m|
			reply_message({
				type: "text",
				text: m.content
			})
		end
	end

end



