class ::Clinics::InfoController < ::Clinics::ApplicationController

  def show

  end

  def update
  	@clinic.update(clinic_params)
  end

  private

  def clinic_params
  	params.require(:clinic).permit(:name, :phone, :phone2, :address)
  end

end
