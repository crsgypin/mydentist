module Common::DeviceHelper

	def device_parse_user_agent(user_agent)
		ua = (user_agent||"").downcase

		#device
		if ua.include?("android")
			device = "android"
		elsif ua.include?("iphone")
			device = "iphone"
		elsif ua.include?("ipad")
			device = "ipad"
		elsif ua.include?("mac")
			device = "mac"
		elsif ua.include?("windows")
			device = "pc"
		else
			device = "other"
		end

		#browser
		if ua.include?("chrome")
			browser = "chrome"
		elsif ua.include?("android")
			browser = "android_browser"
		elsif ua.include?("msie") || ua.include?("trident")
			browser = "ie"
		elsif ua.include?("safari")
			#many browser includes keyword safari, so it needs to put in the last
			browser = "safari"
		else
			browser = "other"
		end

		#app
		if ua.include?("line")
			app = "line"
		elsif ua.include?("facebook") || ua.include?("fb")
			app = "facebook"
		else
			app = nil
		end

		#brand
		if ua.include?("cph")
			brand = "oppo"
		elsif ua.include?("mi ") || ua.include?("mix")
			brand = "mi"
		elsif ua.include?("sm")
			brand = "samsung"
		elsif ua.include?("asus")	
			brand = "asus"
		elsif ua.include?("huawei")
			brand = "huawei"
		elsif ua.include?("a.") || ua.include?("b.")
			brand = "sony"
		elsif ua.include?("iphone") || ua.include?("ipad")
			brand = "apple"
		else
			brand = nil
		end

		r = {
			device: device,
			browser: browser,
			app: app,
			brand: brand
		}
	end

end

