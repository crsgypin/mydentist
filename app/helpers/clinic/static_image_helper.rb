module Clinic::StaticImageHelper


	def clinic_static_image_url(key)
		r = clinic_static_image_urls[key.to_sym]
		raise "invalid key: #{key}" if r.nil?
		r
	end

	def clinic_static_image_urls
		r = {
			calendar: "/imgs/clinics/calendar.png",
			account: "/imgs/clinics/account.png",
			bot: "/imgs/clinics/bot.png",
			doctor: "/imgs/clinics/doctor.png",
			plus_circle: "/imgs/clinics/plus_circle.png",
			teeth: "/imgs/clinics/teeth.png",
			checked_blue: "/imgs/clinics/checked_blue.png",
			checked_green: "/imgs/clinics/checked_green.png",
			cross_red: "/imgs/clinics/cross_red.png",
			line_bot: "/imgs/clinics/line_bot.png"
		}
	end


end
