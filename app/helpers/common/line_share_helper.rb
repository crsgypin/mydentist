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
		# if Rails.env.production?
		# 	url = "#{Rails.application.config_for(:api_key)["liff"]["linebot_event_path"]}?line_account_id=#{line_account.id}"
		# else
		# 	url = Rails.application.routes.url_helpers.linebot_clinic_event_url(clinic, line_account_id: line_account.id, host: Rails.application.config_for(:api_key)["base_domain"])
		# end	
		url = "#{clinic.line_liff_event_url}" + "?"
		url += "&doctor_id=#{args[:doctor_id]}" if args[:doctor_id].present?
		url += "&event_id=#{args[:event_id]}" if args[:event_id].present?
		url += "&event_id=#{args[:hour]}" if args[:hour].present?
		url += "&event_id=#{args[:minute]}" if args[:minute].present?
		url += "&event_id=#{args[:duration]}" if args[:duration].present?
		url += "&event_notification_id=#{args[:event_notification_id]}" if args[:event_notification_id].present?
		url
	end

	def liff_doctor_url(clinic, doctor)
		url = clinic.line_liff_doctor_url
		url += "?doctor_id=#{doctor.id}"
		# if Rails.env.production?
		# 	url = "#{Rails.application.config_for(:api_key)["liff"]["linebot_doctor_path"]}?doctor_id=#{doctor.id}"
		# else
		# 	url = Rails.application.routes.url_helpers.linebot_clinic_doctor_url(clinic, doctor_id: doctor.id, host: Rails.application.config_for(:api_key)["base_domain"])
		# end	
		url
	end

	def liff_patient_binding_url(clinic)
		# if Rails.env.production?
		# 	url = "#{Rails.application.config_for(:api_key)["liff"]["linebot_patient_path"]}"
		# else
		# 	url = Rails.application.routes.url_helpers.new_linebot_clinic_patient_url(clinic, host: Rails.application.config_for(:api_key)["base_domain"])
		# end	
		url = clinic.line_liff_patient_url
		url
	end

end

