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

	def liff_line_event_url(clinic, line_account, args = {})
		if Rails.env.production?
			url = "#{Rails.application.config_for(:api_key)["liff"]["linebot_event_path"]}?line_account_id=#{line_account.id}"
		else
			url = Rails.application.routes.url_helpers.linebot_clinic_event_url(clinic, line_account_id: line_account.id, host: Rails.application.config_for(:api_key)["base_domain"])
		end	
		url += "&doctor_id=#{args[:doctor_id]}" if args[:doctor_id].present?
		url += "&event_id=#{args[:event_id]}" if args[:event_id].present?
		url += "&event_notification_id=#{args[:event_notification_id]}" if args[:event_notification_id].present?
		url
	end

	def liff_doctor_url(clinic, doctor)
		if Rails.env.production?
			url = "#{Rails.application.config_for(:api_key)["liff"]["linebot_doctor_path"]}?doctor_id=#{doctor.id}"
		else
			url = Rails.application.routes.url_helpers.linebot_clinic_doctor_url(clinic, doctor_id: doctor.id, host: Rails.application.config_for(:api_key)["base_domain"])
		end	
		url
	end

end

