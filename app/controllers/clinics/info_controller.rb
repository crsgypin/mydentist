class ::Clinics::InfoController < ::Clinics::ApplicationController

  def show

  end

  def update
  	if !@clinic.update(clinic_params)
  		return js_render_model_error @clinic
  	end
  end

  private

  def clinic_params
  	params.require(:clinic).permit(:name, :phone, :phone2, :address)
  end

end
