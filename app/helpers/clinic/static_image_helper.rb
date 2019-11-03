module Clinic::StaticImageHelper


	def clinic_static_image_url(key)
		r = clinic_static_image_urls[key.to_sym]
		raise "invalid key: #{key}" if r.nil?
		r
	end

	def clinic_static_image_urls
		r = {
		}
	end


end
