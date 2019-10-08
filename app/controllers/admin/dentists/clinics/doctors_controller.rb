class Admin::Dentists::Clinics::DoctorsController < Admin::Dentists::Clinics::ApplicationController
  before_action -> {
    access_config({
      variable_name: "doctor",
      new_resource: proc { @clinic.doctors.new},
      find_resource: proc { @clinic.doctors.find(params[:id])},
      resource_params: proc { params.require(:doctor).permit(@doctor.class.accessable_atts)}
    })
  }

  def index
    @doctors = @clinic.doctors
    @doctors = @doctors.page(params[:page]).per(20)
  end

end
