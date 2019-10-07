class Admin::Dev::Clinics::Patients::ApplicationController < Admin::Dev::Clinics::ApplicationController
  before_action {@embedded = 1}
  before_action :find_patient

  def find_patient
    @patient = @clinic.patients.find(params[:patient_id])
  end
end
