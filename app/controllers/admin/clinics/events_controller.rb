class Admin::Clinics::EventsController < Admin::Clinics::ApplicationController
  before_action -> {
    access_config({
      variable_name: "event",
      new_resource: proc { @clinic.events.new},
      find_resource: proc { @clinic.events.find(params[:id])},
      resource_params: proc { params.require(:event).permit(@event.class.accessable_atts)}
    })
  }

  def index
    @events = @clinic.events.includes(:doctor, :patient, :line_account)
    @events = @events.order(id: :desc)
    @events = @events.page(params[:page]).per(20)
  end

end
