class ::Clinics::EventNotificationSchedulesController < ::Clinics::ApplicationController

	def new
		@event_notification_schedule = @clinic.event_notification_schedules.new

 		if ["回診修改掛號", "診所休假修改掛號", "醫生休假修改掛號"].include? @event_notification_schedule.category
			@event_objs = []
			params[:events] && params[:events].each do |a,v| 
				r = {
					event: @clinic.events.find_by(id: v[:id]),
					args: v[:args]
				}
				@event_objs << r
			end
			return js_render_error "你尚未選擇推播病患" if @event_objs.length == 0
		elsif ["回診推播"].include? @event_notification_schedule.category
			@patient_objs = []
			params[:patients] && params[:patients].each do |a, v|
				r = {
					patient: @clinic.patients.find_by(id: v[:id]),
					args: v[:args]
				}
				@patient_objs << r
			end
			return js_render_error "你尚未選擇推播病患" if @patient_objs.length == 0
		end
	end

	def create
		@event_notification_schedule = @clinic.event_notification_schedules.new

				

	end

end

