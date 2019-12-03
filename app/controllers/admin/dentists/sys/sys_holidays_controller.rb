class Admin::Dentists::Sys::SysHolidaysController < Admin::Dentists::Sys::ApplicationController
  before_action -> {@embedded = 1}, only: :show
  before_action -> {
    access_config({
      variable_name: "sys_holiday",
      new_resource: proc { ::Sys::Holiday.new},
      find_resource: proc { ::Sys::Holiday.find(params[:id])},
      resource_params: proc { params.require(:sys_holiday).permit(Sys::Holiday.accessable_atts)}
    })
  }

  def index
    @sys_holidays = ::Sys::Holiday.all
    @sys_holidays = @sys_holidays.page(params[:page]).per(20)
  end

end
