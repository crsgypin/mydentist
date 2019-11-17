class Linebot::Clinics::PatientsController < Linebot::Clinics::ApplicationController

	def new
	end

	def create
		@line_account = Line::Account.find_by(line_user_id: params[:line_user_id])
		@patient = @clinic.patients.find_by(phone: params[:phone])
		if !@patient.present?
			return @error_code = 1
		elsif @patient.line_account.present?
			return @error_code = 2
		end
		@line_account.update!(patient: @patient)
	end

end

