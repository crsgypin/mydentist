class Admin::Dentists::Clinics::ServicesController < Admin::Dentists::Clinics::ApplicationController
  before_action -> {
    access_config({
      variable_name: "service",
      new_resource: proc { @clinic.services.new},
      find_resource: proc { @clinic.services.find(params[:id])},
      resource_params: proc { params.require(:service).permit(@service.class.accessable_atts)}
    })
  }

  def index
    @services = @clinic.services
    @services = @services.page(params[:page]).per(20)
  end

end
