class Admin::Clinics::Doctors::ApplicationController < Admin::Clinics::ApplicationController
  before_action {@embedded = 1}
  before_action :find_doctor

  def find_doctor
    @doctor = @clinic.doctors.find(params[:doctor_id])
  end
end
