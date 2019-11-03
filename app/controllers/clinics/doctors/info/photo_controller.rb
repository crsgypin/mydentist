class ::Clinics::Doctors::Info::PhotoController < ::Clinics::Doctors::Info::ApplicationController

	def new

	end

	def create
		@doctor.update(photo_params)
	end

	private

	def photo_params
		params.require(:doctor).permit(:photo)
	end


end

