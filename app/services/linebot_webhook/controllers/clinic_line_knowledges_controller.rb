class LinebotWebhook::Controllers::ClinicLineKnowledgesController < LinebotWebhook::Controllers::ApplicationController
	include LinebotWebhook::Replies::ClinicLineKnowledgesReply

	def show
		@clinic_line_knowledge = ClinicLine::Knowledge.find(@message[:data][:id])
		reply_clinic_line_knowledge
	end

end

