module Linebot::StaticImageHelper

	def linebot_static_image_url(key)
		r = linebot_static_image_urls[key.to_sym]
		raise "invalid key: #{key}" if r.nil?
		r
	end

	def linebot_static_image_urls
		r = {
			phone:  "/imgs/linebot/smartphone@3x.png",
			form: "/imgs/linebot/group3Copy@3x.png"
		}
	end


end
