class Admin::Dev::Doctors::EventsController < Admin::Dev::Doctors::ApplicationController
  before_action -> { @embedded = 1}
  before_action -> {
    access_config({
      variable_name: "event",
      new_resource: proc { @doctor.events.new},
      find_resource: proc { @doctor.events.find(params[:id])},
      resource_params: proc { params.require(:event).permit(@event.class.accessable_atts)}
    })
  }

  def index
    @events = @doctor.events
    @events = @events.page(params[:page]).per(20)
  end

end
