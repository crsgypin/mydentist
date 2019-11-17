class Linebot::Clinics::PatientsController < Linebot::Clinics::ApplicationController

	def new
	end

	def show
		@patient = @clinic.patients.find(params[:id])
	end

	def create
		@line_account = Line::Account.find_by(line_user_id: params[:line_user_id])
		if params[:action] == "biding"
			@patient = @clinic.patients.find_by(phone: params[:phone])
			if !@patient.present?
				return @error_code = 1
			elsif @patient.line_account.present?
				return @error_code = 2
			end
			@line_account.update!(patient: @patient)
		elsif params[:action] == "pateint_form"
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

