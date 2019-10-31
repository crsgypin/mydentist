class ::Clinics::PatientsController < ::Clinics::ApplicationController
  before_action -> {
    access_config({
      variable_name: "patient",
      new_resource: proc { @clinic.patients.new},
      find_resource: proc { @clinic.patients.find(params[:id])},
      # resource_params: proc { params.require(:patient).permit(:name, :gender, :person_id, :default_doctor_id, :health_insurance_status, :roc_year, :month, :day, :phone, :phone2, :address, :note)}
    })
  }

  def index
    @patients = @clinic.patients.includes(:line_account, :clinic_patient_notification, :default_doctor, :current_event, :last_tooth_cleaning_event)
    if params[:key].present?
      @patients = @patients.where("name like ?", "%#{params[:key]}%")
    end
    @patients = @patients.page(params[:page]).per(10)
  end

  def update
    @patient = @clinic.patients.find(params[:id])
    if !@patient.update(patient_params)
      return js_render_model_error(@patient)
    end
  end

  private

  def patient_params
    params.require(:patient).permit(:name, :gender, :person_id, :default_doctor_id, :health_insurance_status, :roc_year, :month, :day, :phone, :phone2, :address, :note)
  end

end
