class ::Clinics::Info::ClinicVacations::ApplicationController < ::Clinics::Info::ApplicationController
	before_action :set_clinic_vacation

	def set_clinic_vacation
		@clinic_vacation = @clinic.clinic_vacations.find(params[:clinic_vacation_id])
	end
	
end