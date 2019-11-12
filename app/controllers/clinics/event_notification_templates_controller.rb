class ::Clinics::EventNotificationTemplatesController < ::Clinics::ApplicationController

	def show
		@event_notification_template = @clinic.event_notification_templates.find(params[:id])

		if ["回診修改掛號", "診所休假修改掛號", "醫生休假修改掛號"].include? @event_notification_template.category
			@event_objs = []
			params[:events].each do |a,v| 
				r = {
					event: @clinic.events.find_by(id: v[:id]),
					args: v[:args]
				}
				@event_objs << r
			end
			return js_render_error "你尚未選擇推播病患" if @event_objs.length == 0
		else
			@patient_objs = []
			params[:patients].each do |a, v|
				r = {
					patient: @clinic.patients.where(id: params[:patient_ids]),
					args: v[:args]
				}
			end
			return js_render_error "你尚未選擇推播病患" if @patient_objs.length == 0
		end
	end

end

