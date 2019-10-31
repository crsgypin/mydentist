class ::Clinics::PatientsController < ::Clinics::ApplicationController
  before_action -> {
    access_config({
      variable_name: "patient",
      new_resource: proc { @clinic.patients.new},
      find_resource: proc { @clinic.patients.find(params[:id])},
      resource_params: proc { params.require(:patient).permit(@patient.class.accessable_atts)}
    })
  }

  def index
    @patients = @clinic.patients.includes(:line_account, :clinic_patient_notification, :default_doctor, :current_event, :last_tooth_cleaning_event)
    if params[:key].present?
      @patients = @patients.where("name like ?", "%#{params[:key]}%")
    end
    @patients = @patients.page(params[:page]).per(20)
  end

end
