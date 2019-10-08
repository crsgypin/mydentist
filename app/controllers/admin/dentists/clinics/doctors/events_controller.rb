class Admin::Dentists::Clinics::Doctors::EventsController < Admin::Dentists::Clinics::Doctors::ApplicationController
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
    @events = @events.order(id: :desc)
    @events = @events.page(params[:page]).per(20)
  end

end
