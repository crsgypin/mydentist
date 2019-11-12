module VacationEventsQueryConcern

	def query_vacation_events
		if params[:line_account_status].present?
			if params[:line_account_status] == "0"
				ids = @events.joins(:patient => :line_account).pluck(:id)
				@events = @events.where.not(id: ids)
			elsif params[:line_account_status] == "1"
				ids = @events.joins(:patient => :line_account).pluck(:id)
				@events = @events.where(id: ids)
			end
		end
	end

end

