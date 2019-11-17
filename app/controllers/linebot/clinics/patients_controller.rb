class Linebot::Clinics::PatientsController < Linebot::Clinics::ApplicationController

	def new
		respond_to do |format|
			format.html do
				if params[:patient_form] == '1'
					@mode = "patient_form"
				else
					@mode = "binding"
				end
			end
			format.js do
				#for check line_user_id
				@line_account = @clinic.line_accounts.find_by(line_user_id: params[:line_user_id])
			end
		end

	end

	def show
		@patient = @clinic.patients.find(params[:id])
	end

	def create
		@line_account = Line::Account.find_by!(line_user_id: params[:line_user_id])
		@mode = params[:mode]
		if @mode == "binding"
			@patient = @clinic.patients.find_by(phone: params[:phone])
			if !@patient.present?
				return @error_code = 1
			elsif @patient.line_account.present?
				return @error_code = 2
			end
			@line_account.update!(patient: @patient)
		elsif @mode == "patient_form"
	    ActiveRecord::Base.transaction do 		
				@patient = @clinic.patients.new(patient_params)
				if !@patient.save
					return js_render_model_error @patient
				end
				@line_account.update!(patient: @patient)
			end
		end
	end

	private

  def patient_params
    params.require(:patient).permit(:name, :gender, :person_id, :default_doctor_id, :health_insurance_status, :roc_year, :month, :day, :phone, :phone2, :address, :note)
  end

end

