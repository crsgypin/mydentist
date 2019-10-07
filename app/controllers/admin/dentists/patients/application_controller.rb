class Admin::Dentists::Patients::ApplicationController < Admin::Dentists::ApplicationController
  before_action {@embedded = 1}
  before_action :find_patient

  def find_patient
    @patient = Patient.find(params[:patient_id])
  end
end
