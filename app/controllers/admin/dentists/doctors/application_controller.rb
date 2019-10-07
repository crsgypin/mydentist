class Admin::Dentists::Doctors::ApplicationController < Admin::Dentists::ApplicationController
  before_action {@embedded = 1}
  before_action :find_doctor

  def find_doctor
    @doctor = Doctor.find(params[:doctor_id])
  end
end
