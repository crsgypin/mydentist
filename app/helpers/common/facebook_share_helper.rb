module Common::FacebookShareHelper

	#reference:  https://developers.facebook.com/docs/sharing/reference/share-dialog
	def facebook_share_link_path(m)
		# url = "https://www.facebook.com/dialog/share?app_id=674728496322953"
  # 	url += "&display=popup"
  # 	url += "&href=#{m}"
  #   url += "&redirect_uri=https%3A%2F%2Fdevelopers.facebook.com%2Ftools%2Fexplorer"
  #   url
  	"javascript: window.FB.ui({method: 'share', href: '#{m}'}, function(){})"
	end

end

