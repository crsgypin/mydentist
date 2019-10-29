class ::Clinics::ClinicLine::KnowledgeCategories::KnowledgesController < ::Clinics::ClinicLine::KnowledgeCategories::ApplicationController

	def index
		@clinic_line_knowledges = @clinic_line_knowledge_category.knowledges.includes(:line_template)
	end

	def new
		@clinic_line_knowledge = @clinic_line_knowledge_category.knowledges.new
		@line_template = @clinic_line_knowledge.build_line_template
	end

	def create
		@clinic_line_knowledge = @clinic_line_knowledge_category.knowledges.create
		@line_template = @clinic_line_knowledge.create_line_template
		update_line_template
	end

	def edit
		@clinic_line_knowledge = @clinic_line_knowledge_category.knowledges.find(params[:id])
		@line_template = @clinic_line_knowledge.line_template
	end

	def update
		@clinic_line_knowledge = @clinic_line_knowledge_category.knowledges.find(params[:id])
		@line_template = @clinic_line_knowledge.line_template
		update_line_template
	end

	def destroy
		@clinic_line_knowledge = @clinic_line_knowledge_category.knowledges.find(params[:id])
		if !@clinic_line_knowledge.destroy
			return js_render_model_error(@clinic)
		end
	end

end