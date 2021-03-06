class Admin::Dentists::Clinics::LineConfigController < Admin::Dentists::Clinics::ApplicationController
  before_action -> {
    access_config({
      variable_name: "clinic",
      find_resource: proc { @clinic},
      resource_params: proc { params.require(:clinic).permit(@clinic.class.accessable_atts)}
    })
  }


end
