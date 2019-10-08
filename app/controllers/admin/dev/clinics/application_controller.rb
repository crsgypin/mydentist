class Admin::Dev::Clinics::ApplicationController < Admin::Dev::ApplicationController
  before_action {@embedded = 1}
  before_action :find_clinic

  def find_clinic
    @clinic = Clinic.find_by(friendly_id: params[:clinic_id])
  end
end
