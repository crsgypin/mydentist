class Admin::Dev::LinebotController < Admin::Dev::ApplicationController

	def new
		@clinic = Clinic.first
	end

	def create
		@clinic = Clinic.find_by(friendly_id: params[:clinic_id])
		linebot_webhook =  LinebotWebhook.new(params["events"], @clinic)
		messages = linebot_webhook.parse
		@line_account = linebot_webhook.line_account
		@data = messages.map do |message|
			r = {
				reply_message: message,
				line_account: @line_account.attributes,
			}
		end
		@data = @data.first
	end

end