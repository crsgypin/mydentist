module Common::StaticImageHelper


	def common_static_image_url(key)
		r = common_static_image_urls[key.to_sym]
		raise "invalid key: #{key}" if r.nil?
		r
	end

	def common_static_image_urls
		r = {
			dentist1: "/imgs/common/dentist/dentist-picture.png",
			dentist2: "/imgs/common/dentist/dentist-picture@2x.png",
			dentist3: "/imgs/common/dentist/dentist-picture@3x.png",
			pic_edit1:  "/imgs/common/pic_edit/pic-edit.png",
			pic_edit2:  "/imgs/common/pic_edit/pic-edit@2x.png",
			pic_edit3:  "/imgs/common/pic_edit/pic-edit@3x.png",
		}
	end


end
