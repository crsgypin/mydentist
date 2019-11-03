class ::Clinics::Info::PhotoController < ::Clinics::Info::ApplicationController

	def new

	end

	def create
		@clinic.update(photo_params)
	end

	private

	def photo_params
		params.require(:clinic).permit(:photo)
	end


end

