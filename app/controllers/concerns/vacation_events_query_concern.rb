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
		if params[:has_sending].present?
			if params[:has_sending] == "1"
				ids = @events.joins(:event_notifications).pluck(:id)
				@events = @events.where(id: ids)
			elsif params[:has_sending] == "2"
				ids = @events.joins(:event_notifications).pluck(:id)
				@events = @events.where.not(id: ids)
			end	
		end
		if params[:sending_status].present?
			ids = @events.joins(:event_notifications).where("event_notifications.status = ?", params[:sending_status]).pluck(:id)
			@events = @events.where.not(id: ids)
		end
	end

end

