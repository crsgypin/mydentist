class ::Clinics::Events::Selector::SearchEventsController < ::Clinics::ApplicationController

	def index
		@key = params[:key] || ""
		if !@key.present?
			@evenrts = []
			return
		end

		@events = @clinic.events.valid_events
		ids = @events.joins(:patient).where("patients.name like ?", "%#{@key}%")
		@events = @events.order(date: :desc)
		@events = @events.where(id: ids)
	end

end

