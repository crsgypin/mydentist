module Common::LineShareHelper

	def line_share_add_friend_path
		Rails.application.config_for(:api_key)['line']['add_friend_url']
	end

	def line_bot_id
		Rails.application.config_for(:api_key)['line']['bot_line_id']
	end

	def line_share_message_path(message)
		m = URI.decode(message)
		"https://line.me/R/msg/text/?#{m}"
	end

end

