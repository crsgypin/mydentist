class ::Clinics::Members::PhotoController < ::Clinics::Members::ApplicationController

	def new

	end

	def create
		@member.update(photo_params)
	end

	private

	def photo_params
		params.require(:member).permit(:photo)
	end


end

