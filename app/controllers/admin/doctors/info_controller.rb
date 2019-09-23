class Admin::Doctors::InfoController < Admin::Doctors::ApplicationController
  before_action -> {
    access_config({
      variable_name: "doctor",
      find_resource: proc { @doctor},
      resource_params: proc { params.require(:doctor).permit(@doctor.class.accessable_atts)}
    })
  }


end
