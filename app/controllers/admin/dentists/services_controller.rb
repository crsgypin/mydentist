class Admin::Dentists::ServicesController < Admin::Dentists::ApplicationController
  before_action -> {@embedded = 1}, only: [:show]
  before_action -> {
    access_config({
      variable_name: "service",
      new_resource: proc { ::Service.new},
      find_resource: proc { ::Service.find(params[:id])},
      resource_params: proc { params.require(:service).permit(Service.accessable_atts)}
    })
  }

  def index
    @services = ::Service.all
    @services = @services.page(params[:page]).per(20)
  end

end
