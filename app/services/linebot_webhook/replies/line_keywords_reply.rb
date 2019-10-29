module LinebotWebhook::Replies::LineKeywordsReply

	def reply_line_keyword
		@line_template.template_messages.map do |m|
			reply_message({
				type: "text",
				text: m.content
			})
		end
	end

end

