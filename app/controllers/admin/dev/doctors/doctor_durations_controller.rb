class Admin::Dev::Doctors::DoctorDurationsController < Admin::Dev::Doctors::ApplicationController
  before_action -> {
    access_config({
      variable_name: "doctor_duration",
      new_resource: proc { @doctor.doctor_durations.new},
      find_resource: proc { @doctor.doctor_durations.find(params[:id])},
      resource_params: proc { params.require(:doctor_duration).permit(@doctor_duration.class.accessable_atts)}
    })
  }

  def index
    @doctor_durations = @doctor.doctor_durations
    @doctor_durations = @doctor_durations.page(params[:page]).per(20)
  end

end
