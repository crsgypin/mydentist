class ::Clinics::DoctorsController < ::Clinics::ApplicationController
  before_action -> {@doctor_sidemenu = 1 }, only: :new

  def index
    @doctors = @clinic.doctors
    @doctors = @doctors.page(params[:page]).per(20)
  end

  def new
    @doctor = @clinic.doctors.new
  end

  def show
    redirect_to clinic_doctor_info_path(@clinic, params[:id])
  end

  def create
    @doctor = @clinic.doctors.new(doctor_params)
    @doctor.save
  end

  def destroy
    @doctor = @clinic.doctors.find(params[:id])
    if !@doctor.destroy
      return js_render_model_error(@doctor)
    end
  end

  private

  def doctor_params
    params.require(:doctor).permit(:name, :title, :experience, :intro, :pro, :web_link, :phone, :note)
  end

end
