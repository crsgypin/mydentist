class ::Clinics::ClinicLine::KnowledgeCategories::KnowledgesController < ::Clinics::ClinicLine::KnowledgeCategories::ApplicationController

	def index
		@clinic_line_knowledges = @clinic_line_knowledge_category.knowledges	
	end

end