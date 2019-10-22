class Admin::Dentists::EventsController < Admin::Dentists::ApplicationController
  before_action -> {@embedded = 1}, only: [:show]
  before_action -> {
    access_config({
      variable_name: "event",
      new_resource: proc { ::Event.new},
      find_resource: proc { ::Event.find(params[:id])},
      resource_params: proc { params.require(:event).permit(Event.accessable_atts)}
    })
  }

  def index
    @events = ::Event.includes(:event_durations)
    @events = @events.page(params[:page]).per(20)
  end

end
