module Common::ImageHelper

	def center_image(image_url, options = {})
		r = ""
		if !options[:href].nil?
			r += "<a href='#{options[:href]}' class='center_image'>"
			r += image_tag image_url, alt: options[:alt]
			r += "</a>"
		else
 			r += "<div class='center_image'>"
			r += image_tag image_url, alt: options[:alt]
			r += "</div>"
		end
		r.html_safe
	end

	def bg_center_image(image_url, options = {})
		r = ""
		if !options[:href].nil?
			r += "<a class='bg_center_image' href='#{options[:href]}' style='background-image: url(#{image_url})'>"
			r += "</a>"
		else
 			r += "<div class='bg_center_image' style='background-image: url(#{image_url})'>"
			r += "</div>"
		end
		r.html_safe
	end

end