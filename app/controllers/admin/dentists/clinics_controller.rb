class Admin::ClinicsController < Admin::ApplicationController
  before_action -> {@embedded = 1}, only: [:show]
  before_action -> {
    access_config({
      variable_name: "clinic",
      new_resource: proc { ::Clinic.new},
      find_resource: proc { ::Clinic.find_by(friendly_id: params[:id])},
      resource_params: proc { params.require(:clinic).permit(Clinic.accessable_atts)}
    })
  }

  def index
    @clinics = ::Clinic.all
    @clinics = @clinics.page(params[:page]).per(20)
  end

end
