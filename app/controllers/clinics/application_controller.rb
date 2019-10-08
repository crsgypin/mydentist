class Clinics::ApplicationController < ApplicationController
	layout 'clinics'
	before_action :set_clinic
	before_action :set_member
  include JsCrudConcern

	def set_clinic
		@clinic = Clinic.find_by(friendly_id: params[:clinic_id])
	end

	def set_member
		if current_member.nil? || current_member.clinic != @clinic
			return redirect_to new_member_session_path
		end
	end

end