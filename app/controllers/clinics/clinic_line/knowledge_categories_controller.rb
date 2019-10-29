class ::Clinics::ClinicLine::KnowledgeCategoriesController < ::Clinics::ClinicLine::ApplicationController
	before_action :set_clinic_line_knowledge_categories

	def index
		@clinic_line_knowledge_category = @clinic_line_knowledge_categories.first
		render "show"
	end

	def show
		@clinic_line_knowledge_category = @clinic_line_knowledge_categories.find(params[:id])
	end

	def edit
		@clinic_line_knowledge_category = @clinic_line_knowledge_categories.find(params[:id])
	end

	def update
		@clinic_line_knowledge_category = @clinic_line_knowledge_categories.find(params[:id])
		@clinic_line_knowledge_category.update(clinic_line_knowledge_category_params)
	end

	private

	def set_clinic_line_knowledge_categories
		@clinic_line_knowledge_categories = @clinic.clinic_line_knowledge_categories
		if @clinic_line_knowledge_categories.length == 0
			@clinic_line_knowledge_category = @clinic.clinic_line_knowledge_categories.create(name: "未分類")
			@clinic_line_knowledge_categories.push(@clinic_line_knowledge_category)
		end
	end

	def clinic_line_knowledge_category_params
		params.require(:clinic_line_knowledge_category).permit(:name)
	end

end