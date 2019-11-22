class ::Clinics::Events::Selector::SearchEventsController < ::Clinics::ApplicationController

	def index
		@key = params[:key] || ""
		if !@key.present?
			@evenrts = []
			return
		end

		@events = @clinic.events.all
		ids = @events.joins(:patient).where("patients.name like ?", "%#{@key}%")
		@events = @events.order(id: :desc)
		@events = @events.where(id: ids)
	end

end

