class ::Clinics::Doctors::InfoController < ::Clinics::Doctors::ApplicationController
	# rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid

	def show

	end

	def update
		@doctor.update!(doctor_params)
	end

	private

	def doctor_params
		params.require(:doctor).permit(:name, :title, :pro, :experience, :web_link, :phone, :note)
	end

end