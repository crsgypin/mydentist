module ClinicLineAccountConcern
	include Common::LineShareHelper

	def base_domain
		Rails.application.config_for(:api_key)["base_domain"]
	end

	def add_line_friend_path
		# Rails.application.config_for(:api_key)['line']['add_friend_url']
		"https://line.me/R/ti/p/#{self.line_account_id}"
	end

	# def line_binding_url
	# 	liff_patient_binding_url(self)
	# end

	def line_urls_complete
		r = []
		r << "line_account_id" if !line_account_id.present?
		r << "line_channel_id" if !line_channel_id.present?
		r << "line_channel_secret" if !line_channel_secret.present?
		r << "line_channel_access_token" if !line_channel_access_token.present?
		r << "line_liff_event_url" if !line_liff_event_url.present?
		r << "line_liff_doctor_url" if !line_liff_doctor_url.present?
		r << "line_liff_patient_url" if !line_liff_patient_url.present?
		if r.length > 0
			"缺少: #{r.join(", ")}"
		else
			"已完成"
		end
	end

	def line_developer_url
		"https://developers.line.biz/console/channel/#{self.line_channel_id}"
	end

	def line_liff_event_url
		self[:line_liff_event_url] || ""
	end

	def line_liff_doctor_url
		self[:line_liff_doctor_url] || ""
	end

	def line_liff_patient_url
		self[:line_liff_patient_url] || ""
	end

	#web 開頭表示本網站
	def web_webhook_url
		"#{base_domain}/linebot/clinics/#{self.friendlly_id}/webhook"
	end

	def web_liff_event_url
		Rails.application.routes.url_helpers.linebot_clinic_event_url(self, host: base_domain)
	end

	def web_liff_doctor_url
		Rails.application.routes.url_helpers.linebot_clinic_doctor_url(self, host: base_domain)
	end

	def web_liff_patient_url
		Rails.application.routes.url_helpers.new_linebot_clinic_patient_url(self, host: base_domain)
	end

end
