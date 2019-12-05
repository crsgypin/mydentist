module LinebotWebhook::Replies::LineKeywordsReply

	def reply_line_keyword
		@line_template.template_messages.map do |m|
			if m.category == "text"
				reply_message({
					type: "text",
					text: m.content
				})
			elsif m.category == "image"
				reply_message({
					type: "image",
					image_url: m.file.url
				})
			end
		end
	end

end

