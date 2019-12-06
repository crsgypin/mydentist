class ::Clinics::Events::Selector::LineAccountsController < ::Clinics::ApplicationController

	def new
		@patient = @clinic.patients.find(params[:patient_id])
	end

	def create
		@patient = @clinic.patients.find(params[:patient_id])
	end

end

