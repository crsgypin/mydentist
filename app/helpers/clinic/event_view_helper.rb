module Clinic::EventViewHelper

	def list_event_view(event)
		r = "<div id='#{"list_event_#{event.id}"}'>"
		r += link_to icon_tag(:check_circle), clinic_event_path(@clinic, event, change_status: 1, event: {status: event.status == "報到" ? "已預約" : "報到"}), remote: true, method: "patch", class: "check_in #{"selected" if event.status == "報到"}"
		r += link_to icon_tag(:close_circle), clinic_event_path(@clinic, event, change_status: 1, event: {status: event.status == "爽約" ? "已預約" : "爽約"}), remote: true, method: "patch", class: "break #{"selected" if event.status == "爽約"}"
		r += "</div>"
		r.html_safe
	end

	def day_event_view(event)
    r = "<div class='status' id='day_event_#{event.id}'>"
    r += " 	<div class='line_box #{"selected" if event.source == "網路"}'>"
		r += image_tag clinic_static_image_url(:line_bot)
    r += " </div>"
    r += "<div class='check_in #{"selected" if event.status == "報到"}' id= '#{"check_id_#{event.id}"}'>"
		r += image_tag clinic_static_image_url(:checked_green)
    r += " </div>"
    r += " <div class='break #{"selected" if event.status == "爽約"}' id='#{"break_#{event.id}"}'>"
		r += image_tag clinic_static_image_url(:cross_red)
    r += " </div>"
    r += "</div>"
    r.html_safe
	end

end

