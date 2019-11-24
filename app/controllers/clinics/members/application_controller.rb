class ::Clinics::Members::ApplicationController < ::Clinics::ApplicationController
	before_action :set_member

	def set_member
		@member = @clinic.members.find(params[:member_id])
	end

end

