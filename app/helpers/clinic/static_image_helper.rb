module Clinic::StaticImageHelper


	def clinic_static_image_url(key)
		r = clinic_static_image_urls[key.to_sym]
		raise "invalid key: #{key}" if r.nil?
		r
	end

	def clinic_static_image_urls
		r = {
			account: "/imgs/clinics/account.png",
			bot: "/imgs/clinics/bot.png",
			doctor: "/imgs/clinics/doctor.png",
			plus_circle: "/imgs/clinics/plus_circle.png",
			teeth: "/imgs/clinics/teeth.png"
		}
	end


end
