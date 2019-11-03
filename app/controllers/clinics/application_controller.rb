class Clinics::ApplicationController < ApplicationController
	layout 'clinics'
	before_action :set_clinic
	before_action :set_member
  include JsCrudConcern
	rescue_from ActiveRecord::RecordInvalid, with: :show_errors

	def set_clinic
		@clinic = Clinic.find_by(friendly_id: params[:clinic_id])
	end

	def set_member
		if current_member.nil? || current_member.clinic != @clinic
			return redirect_to new_member_session_path
		end
	end

	def show_errors(exception)
		#reference: https://apidock.com/rails/ActiveSupport/Rescuable/ClassMethods/rescue_from
		if request.format.js?
			js_render_model_error exception.record
			return
		end
		super
	end


end