class Admin::Dentists::Clinics::ClinicHolidaysController < Admin::Dentists::Clinics::ApplicationController
  before_action -> {
    access_config({
      variable_name: "clinic_holiday",
      new_resource: proc { @clinic.clinic_holidays.new},
      find_resource: proc { @clinic.clinic_holidays.find(params[:id])},
      resource_params: proc { params.require(:clinic_holiday).permit(@clinic_holiday.class.accessable_atts)}
    })
  }

  def index
    @clinic_holidays = @clinic.clinic_holidays
    @clinic_holidays = @clinic_holidays.page(params[:page]).per(20)
  end

end
