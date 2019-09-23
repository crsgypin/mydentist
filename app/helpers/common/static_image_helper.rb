module Common::StaticImageHelper


	def common_static_image_url(key)
		r = common_static_image_urls[key.to_sym]
		raise "invalid key: #{key}" if r.nil?
		r
	end

	def common_static_image_urls
		r = {
		}
	end


end
