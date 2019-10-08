class Admin::Dev::DoctorsController < Admin::Dev::ApplicationController
  before_action -> { @embedded = 1}, only: [:show, :edit]
  before_action -> {
    access_config({
      variable_name: "doctor",
      new_resource: proc { ::Doctor.new},
      find_resource: proc { ::Doctor.find(params[:id])},
      resource_params: proc { params.require(:doctor).permit(Doctor.accessable_atts)}
    })
  }

  def index
    @doctors = ::Doctor.all
    @doctors = @doctors.page(params[:page]).per(20)
  end

end
