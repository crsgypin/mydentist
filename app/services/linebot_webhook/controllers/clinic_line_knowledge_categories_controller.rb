class LinebotWebhook::Controllers::ClinicLineKnowledgeCategoriesController < LinebotWebhook::Controllers::ApplicationController
	include LinebotWebhook::Replies::ClinicLineKnowledgeCategoriesReply

	def index
		@clinic_line_knowledge_categories = @clinic.clinic_line_knowledge_categories.includes(:knowledges => [:line_template => [:keywords, :template_messages]])
		reply_clinic_line_knowledge_categories
	end

end

