module Common::IconHelper

	def icon_tag(name, option={})
		r1 = icons[name.to_sym]
		raise "invlid icon name: #{name}" if r1.nil?
		option[:class] = option[:class].present? ? "#{option[:class]} #{r1}" : r1
		c = content_tag(:i, "", option)
		c
	end

	def icon_class(name)
		r1 = icons[name.to_sym]
		raise "invlid icon name: #{name}" if r1.nil?
		r1
	end

	def icons
		@icons ||= {
			link: "fas fa-link",
			bold: "fas fa-bold",
			chevron_circle_right: "fas fa-chevron-circle-right",
			chevron_down: "fas fa-chevron-down",
			italic: "fas fa-italic",
			commentn_plus: "fas fa-comment-medical", #https://fontawesome.com/icons/comment-medical?style=solid
			notification: "fas fa-bell",
			bookmark_fill: "fas fa-bookmark",
			bookmark: "far fa-bookmark",
			#以下為其他網站參考
			circle_up: "fas fa-arrow-alt-circle-up",
			copy: "fas fa-copy",
			share: "fas fa-share-alt",
			close: "fas fa-times",
			trash: "fas fa-trash",
			comment: "far fa-comment",
			thumb: "far fa-thumbs-up",
			thumb_fill: "fas fa-thumbs-up",
			plus: "fas fa-plus",
			camera: "fas fa-camera",
			google: "fab fa-google",
			search: "fas fa-search",
			pencil: "fas fa-pencil-alt",
			sign_out: "fas fa-sign-out-alt",
			list: "fas fa-list",
			home: "fas fa-home",
			star: "far fa-star",
			unlock: "fas fa-unlock-alt",
			reader: "fas fa-book-reader",
			star_fill: "fas fa-star",
			cancel: "fas fa-times",
			dolor: "fas fa-dollar-sign",
			map_marker: "fas fa-map-marker-alt",
			bars: "fas fa-bars",
			landmark: "fas fa-landmark",
			fb: "fab fa-facebook-f",
			fb_square: "fab fa-facebook-square",
			tag: "fas fa-tag",
			email: "far fa-envelope",
			square: "fas fa-square",
			file: "fas fa-file",
			shopping_cart: "fas fa-shopping-cart",
			user_headset: "far fa-user-headset",
			headphone: "fas fa-headphones",
			phone: "fas fa-phone",
			user: "fas fa-user",
			add_user: "fas fa-user-plus",
			reply: "fas fa-reply",
			setting: "fas fa-cog",
			question_circle: "fas fa-question-circle",
			dots: "fas fa-ellipsis-h", #or more
			check_circle: "fas fa-check-circle",
			link_external: "fas fa-external-link-square-alt",
			mobile: "fa fa-mobile",
			angle_right: "fas fa-angle-right",
			eye: "fas fa-eye",
			fix: "fas fa-wrench",
			globe: "fas fa-globe",
			angle_left: "fas fa-angle-left",
			edit: "fas fa-edit",
			images: "fas fa-images"
		}
	end

end
