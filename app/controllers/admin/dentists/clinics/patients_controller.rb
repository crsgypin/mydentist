class Admin::Dentists::Clinics::PatientsController < Admin::Dentists::Clinics::ApplicationController
  before_action -> {
    access_config({
      variable_name: "patient",
      new_resource: proc { @clinic.patients.new},
      find_resource: proc { @clinic.patients.find(params[:id])},
      resource_params: proc { params.require(:patient).permit(@patient.class.accessable_atts)}
    })
  }

  def index
    @patients = @clinic.patients
    @patients = @patients.page(params[:page]).per(20)
  end

end
