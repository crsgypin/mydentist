module Common::HeadHelper

	def head_image_url
		@head_image_url ||= ""
		@head_image_url
	end

	def head_title
		@head_title ||= "無想牙醫診所小助手"
	end

	def head_description
		@head_description ||= "無想牙醫診所小助手"
	end

	def head_keywords
		@head_keywords ||= "無想牙醫診所小助手"
	end

	def head_fb_id
		Rails.application.config_for(:api_key)["facebook"]["app_id"]
	end

end
