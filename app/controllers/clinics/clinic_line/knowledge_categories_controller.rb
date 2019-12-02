class ::Clinics::ClinicLine::KnowledgeCategoriesController < ::Clinics::ClinicLine::ApplicationController
	before_action :set_clinic_line_knowledge_categories

	def index
		@clinic_line_knowledge_category = @clinic_line_knowledge_categories.first
		render "show"
	end

	def new
		@clinic_line_knowledge_category = @clinic_line_knowledge_categories.new
	end

	def create
		@clinic_line_knowledge_category = @clinic_line_knowledge_categories.new(clinic_line_knowledge_category_params)
		if !@clinic_line_knowledge_category.save
			return js_render_model_error(@clinic_line_knowledge_category)
		end
	end

	def show
		@clinic_line_knowledge_category = @clinic_line_knowledge_categories.find(params[:id])
	end

	def edit
		@clinic_line_knowledge_category = @clinic_line_knowledge_categories.find(params[:id])
	end

	def update
		@clinic_line_knowledge_category = @clinic_line_knowledge_categories.find(params[:id])
		if !@clinic_line_knowledge_category.update(clinic_line_knowledge_category_params)
			return js_render_model_error(@clinic_line_knowledge_category)
		end
	end

	private

	def set_clinic_line_knowledge_categories
		10.times do |index|
			@clinic.clinic_line_knowledge_categories[index].nil? && @clinic.clinic_line_knowledge_categories.create(name: "衛教資訊#{index + 1}")
		end
		@clinic_line_knowledge_categories = @clinic.clinic_line_knowledge_categories
	end

	def clinic_line_knowledge_category_params
		params.require(:clinic_line_knowledge_category).permit(:name)
	end

end