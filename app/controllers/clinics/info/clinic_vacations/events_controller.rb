class ::Clinics::Info::ClinicVacations::EventsController < ::Clinics::Info::ClinicVacations::ApplicationController

	def index
		@key = params[:key] || "events"

		@events = @clinic_vacation.events.includes(:event_notifications, :patient)

		if params[:line_account_status].present?
			if params[:line_account_status] == "0"
				ids = @events.joins(:patient => :line_account).pluck(:id)
				@events = @events.where.not(id: ids)
			elsif params[:line_account_status] == "1"
				ids = @events.joins(:patient => :line_account).pluck(:id)
				@events = @events.where(id: ids)
			end
		end

		@events = @events.order(date: :asc, hour: :asc, minute: :asc)
	end

end
