class ::Clinics::ClinicLine::KnowledgeCategories::ApplicationController < ::Clinics::ClinicLine::ApplicationController
	before_action :set_knowledge_category

	def set_knowledge_category
		@clinic_line_knowledge_category = @clinic.clinic_line_knowledge_categories.find(params[:knowledge_category_id])
	end

end