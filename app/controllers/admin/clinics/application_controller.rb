class Admin::Clinics::ApplicationController < Admin::ApplicationController
  before_action {@embedded = 1}
  before_action :find_clinic

  def find_clinic
    @clinic = Clinic.find(params[:clinic_id])
  end
end
