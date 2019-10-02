class LinebotWebhook::Controllers::ClinicController < LinebotWebhook::Controllers::ApplicationController
	include LinebotWebhook::Replies::ClinicReply

	def show
		if @message[:type] == "message"
			if @message[:text] == "診所資訊"
				reply_clinic_info_selectors
			end
		elsif @message[:type] == "postback"
			if @message[:data][:type] == "duration"
				reply_clinic_duration
			elsif @message[:data][:type] == "traffic"
				reply_clinic_traffic
			elsif @message[:data][:type] == "contact"
				reply_clinic_contact
			end
		end		
	end

end

