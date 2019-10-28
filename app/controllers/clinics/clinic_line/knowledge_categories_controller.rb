class ::Clinics::ClinicLine::KnowledgeCategoriesController < ::Clinics::ClinicLine::ApplicationController

	def index
		set_clinic_line_knowledge_categories
		@clinic_line_knowledge_category = @clinic_line_knowledge_categories.first
	end

	def show
		set_clinic_line_knowledge_categories
		@clinic_line_knowledge_category = @clinic_line_knowledge_categories.find(params[:id])
		@clinic_line_knowledges = @clinic_line_knowledge_category.knowledges
	end

	private

	def set_clinic_line_knowledge_categories
		@clinic_line_knowledge_categories = @clinic.clinic_line_knowledge_categories
		if @clinic_line_knowledge_categories.length == 0
			@clinic_line_knowledge_category = @clinic.clinic_line_knowledge_categories.create(name: "未分類")
			@clinic_line_knowledge_categories.push(@clinic_line_knowledge_category)
		end
	end

end