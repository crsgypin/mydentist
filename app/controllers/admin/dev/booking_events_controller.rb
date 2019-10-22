class Admin::Dev::BookingEventsController < Admin::Dev::ApplicationController
  before_action -> {@embedded = 1}, only: [:show]
  before_action -> {
    access_config({
      variable_name: "booking_event",
      new_resource: proc { ::BookingEvent.new},
      find_resource: proc { ::BookingEvent.find(params[:id])},
      resource_params: proc { params.require(:booking_event).permit(::BookingEvent.accessable_atts)}
    })
  }

  def index
    @booking_events = ::BookingEvent.all
    @booking_events = @booking_events.page(params[:page]).per(20)
  end

end


