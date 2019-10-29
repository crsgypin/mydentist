class LinebotWebhook::Controllers::LineKeywordsController < LinebotWebhook::Controllers::ApplicationController
	include LinebotWebhook::Replies::LineKeywordsReply

	def show
		@line_keyword = Line::Keyword.find_by(name: @message[:text])
		@line_template = @line_keyword.template
		reply_line_keyword
	end

end



