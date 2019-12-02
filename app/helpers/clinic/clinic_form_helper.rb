module Clinic::ClinicFormHelper

	def clinic_field_box(args)
		title = args[:title]
		value = args[:value]
		r = "<div class='field_box'>"
		r += "<div class='title'>#{title}</div>"
		r += value
		r += "</div>"
		r.html_safe
	end

end

