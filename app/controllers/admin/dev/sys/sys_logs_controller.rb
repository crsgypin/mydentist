class Admin::Dev::Sys::SysLogsController < Admin::Dev::Sys::ApplicationController
  before_action -> {@embedded = 1}, only: :show
  before_action -> {
    access_config({
      variable_name: "sys_log",
      new_resource: proc { ::Sys::Log.new},
      find_resource: proc { ::Sys::Log.find(params[:id])},
      resource_params: proc { params.require(:sys_log).permit(Sys::Log.accessable_atts)}
    })
  }

  def index
    @sys_logs = ::Sys::Log.all
    @sys_logs = @sys_logs.order(id: :desc)
    @sys_logs = @sys_logs.page(params[:page]).per(20)
  end

end
