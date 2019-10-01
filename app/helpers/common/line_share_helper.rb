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

	def liff_line_event_url(clinic, line_account)
		if Rails.env.production?
			"#{Rails.application.config_for(:api_key)["liff"]["linebot_event_path"]}?line_account_id=#{line_account.id}"
		else
			Rails.application.routes.url_helpers.linebot_clinic_event_url(clinic, line_account_id: line_account.id, host: Rails.application.config_for(:api_key)["base_domain"])
		end	
	end

end

