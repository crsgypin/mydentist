module Accounts::StaticImageHelper

	def accounts_static_image_url(key)
		r = accounts_static_image_urls[key.to_sym]
		raise "invalid key: #{key}" if r.nil?
		r
	end

	def accounts_static_image_urls
		r = {
			email_sent: "/imgs/accounts/email_sent.png",
			no_permission: "/imgs/accounts/no_permission.png",
		}
	end


end
