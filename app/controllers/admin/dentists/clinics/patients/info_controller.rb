class Admin::Dentists::Clinics::Patients::InfoController < Admin::Dentists::Clinics::Patients::ApplicationController
  before_action -> {
    access_config({
      variable_name: "patient",
      find_resource: proc { @patient},
      resource_params: proc { params.require(:patient).permit(@patient.class.accessable_atts)}
    })
  }


end
