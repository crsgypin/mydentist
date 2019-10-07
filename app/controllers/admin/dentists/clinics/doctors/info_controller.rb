class Admin::Dentists::Clinics::Doctors::InfoController < Admin::Dentists::Clinics::Doctors::ApplicationController
  before_action -> {
    access_config({
      variable_name: "doctor",
      find_resource: proc { @doctor},
      resource_params: proc { params.require(:doctor).permit(@doctor.class.accessable_atts)}
    })
  }


end
