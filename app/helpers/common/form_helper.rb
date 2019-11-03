module Common::FormHelper

	def no_image_tag(option={})
		image_tag("/imgs/pages/common/no_image.png", option)
	end

	def date_input(name, value, e = {})
		class_name = e[:class_name]
		width = e[:width]
		html = "<input type=\"text\" name='#{name}' class='#{class_name} date_picker' value='#{value}' style='#{width.present? && "width: #{width}px"}' autocomplete=\"off\">"
		return html.html_safe
	end

	def date_field_tag(name, value, option={})
		html = "<input type=\"text\" name='#{name}' class=\"#{option[:class]} date_picker\" value='#{value}' style=\"#{option[:style]}\">"
		return html.html_safe
	end	

	def submit_button(name, option={})
		option[:class] = option[:class] || ""
		option[:class] += "#{option[:class]} lh4 ph2 "
		r = "<div class='button'>"
		r +=  "<input type=\"submit\" id=\"#{option[:id]}\" class=\"#{option[:class]}\" value=\"#{name}\" onclick=\"#{option[:onclick]||""}\">"
		r += "</div>"
		r.html_safe		
	end

	def title_box(&block)
		s = "<div class=\"title_box pb5 pt5 fs20\">"
		s += capture(&block)
		s += "</div>"
		s.html_safe
	end

	def search_box(&block)
		s = "<div class=\"search_box pb5 pt5 fs12\">"
		s += capture(&block)
		s += "</div>"
		s.html_safe
	end

	def buttons_box(&block)
		r = "<div class=\"button_box pb5 pt5\">"
		r += capture(&block)
		r += "</div>"
		r.html_safe
	end

	def select_field_tag(name, value, options, option={})
		s = ""
		s += "<select name=\"#{name}\" class=\"#{option[:class]}\" onchange=\"#{option[:onchange]}\" id=\"#{option[:id]}\" #{"disabled='true'" if option[:disabled] == true} >"
		options.each do |v, t|
			s += "<option value=\"#{v}\" #{"selected" if v.to_s == value.to_s}>#{t||v}</option>"
		end 
		s += "</select>"
		s.html_safe
	end

	def ckeditor_text_field(name, value, option={})
		option[:class] = "ckeditor_text #{option[:class]}"
		option[:data] ||= {}
		option[:data][:width] ||= "100%"
		option[:data][:height] ||= 300
		option[:data][:uploadurl] ||= nil
		option[:data][:browseurl] ||= nil
		text_area_tag(name, value, option)
	end
	
end
