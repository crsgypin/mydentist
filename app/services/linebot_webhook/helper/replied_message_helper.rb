module LinebotWebhook::Helper::RepliedMessageHelper

	#for server-side message
	def reply_message(data, option = {})
		if data[:type] == "text"
			r = reply_message_text(data)
		elsif data[:type] == "quick_reply_buttons"
			r = reply_message_quick_replies(data)
		elsif data[:type] == "confirm"
			r = reply_message_confirm(data)
		elsif data[:type] == "carousel"
			r = reply_message_carousel(data)
		else
			raise "invalid type: #{data[:type]}"
		end
		Rails.logger.info("reply_message: #{r}")
		r
	end

	private

	def reply_message_text(data)
		r = {
      type: 'text',
      text: data[:text]
		}
	end

	def reply_message_quick_replies(data)
		r = {
			type: "text",
			text: data[:text],
			quickReply: {
				items: data[:items].map do |a| 
					r = {
						type: "action",
						action: filter_action(a)
					}
				end
			}
		}
	end

	def convert_quick_reply_buttons(data)
		#to be removed
		r = {
	      type: "text",
	      text: data[:text],
	      quickReply: {
	      	items: data[:items].map do |i|
	      		item = {
	      			name: i[:name],
	      			data: i[:data]
	      		}
	      		r = {
							type: "action",
							action: {
								type: "postback",
								label: item[:name],
								data: URI.decode(item[:data].to_query),
								displayText: item[:name]
							}      			
	      		}
	      	end
	      }
			}
	end

	def reply_message_confirm(data)
		r = {
			type: "template",
			altText: data[:alt_text],
			template: {
				type: "confirm",
				text: data[:text],
				actions: data[:actions].map{|a| filter_action(a)}
			}
		}
	end

	def reply_message_carousel(data)
 		r = {
			type: "template",
			altText: data[:text],
			template: {
				type: "carousel",
				columns: data[:columns].map do |c|
					column = {
						image_url: c[:image_url],
						bg_color: c[:bg_color],
						title: c[:title],
						text: c[:text],
						name: c[:name],
						default_action: c[:default_action],
						actions: c[:actions]
					}
					#convert
					r = {}
					r[:thumbnailImageUrl] = column[:image_url] if column[:image_url].present?
					r[:imageBackgroundColor] = column[:bg_color] || "#FFFFFF"
					r[:title] = column[:title]
					r[:text] = column[:text]
					r[:defaultAction] = filter_action(column[:default_action])
					r[:actions] = column[:actions].map{|a| filter_action(a)}
					r
				end
			}
		}
		r
	end

	def filter_action(action)
		action.map do |key, value|
			if key.to_sym == :data
				[key, value.to_query]
			else
				[key, value]
			end
		end.to_h
	end

	#action
	#uri
	# {
	# 	type: "uri",
	# 	label: "xxx",
	# 	uri: "xxx"
	# }

#ex: postback
	# {"events"=>[{
	# 	"type"=>"postback", 
	# 	"replyToken"=>"xxxx", 
	# 	"source"=>{
	# 		"userId"=>"xxxx", 
	# 		"type"=>"user"
	# 	}, 
	# 	"timestamp"=>1569777786439, 
	# 	"postback"=>{
	# 		"data"=>"{\"key\":\"event_create\",\"service_name\":\"檢查牙齒\"}"}
	# 	}
	# ], 
	# "destination"=>"U22a90ecxxxx7358", 

#ex: message
	# {"events"=>[{
	# 	"type"=>"message", 
	# 	"replyToken"=>"xxx", 
	# 	"source"=>{
	# 		"userId"=>"xxxx", 
	# 		"type"=>"user"
	# 	}, 
	# 	"timestamp"=>1569687739447, 
	# 	"message"=>{
	# 		"type"=>"text", 
	# 		"id"=>"10649172617448", 
	# 		"text"=>"預約掛號"
	# 	}
	# }], 
	# "destination"=>"U22a90ecxxxx7358", 


	def convert_reply_message1(data, option = {}) #for test
		{
		  "type": "template",
		  "altText": "this is a carousel template",
		  "template": {
		      "type": "carousel",
		      "columns": [
		          {
		            "thumbnailImageUrl": "https://s1.yimg.com/rz/d/yahoo_frontpage_zh-Hant-TW_s_f_p_bestfit_frontpage_2x.png",
		            "imageBackgroundColor": "#FFFFFF",
		            "title": "this is menu",
		            "text": "description",
		            "defaultAction": {
		                "type": "uri",
		                "label": "View detail",
		                "uri": "http://example.com/page/123"
		            },
		            "actions": [
		                {
		                    "type": "postback",
		                    "label": "Buy",
		                    "data": "action=buy&itemid=111"
		                },
		                {
		                    "type": "postback",
		                    "label": "Add to cart",
		                    "data": "action=add&itemid=111"
		                },
		                {
		                    "type": "uri",
		                    "label": "View detail",
		                    "uri": "http://example.com/page/111"
		                }
		            ]
		          },
		          {
		            "thumbnailImageUrl": "https://example.com/bot/images/item2.jpg",
		            "imageBackgroundColor": "#000000",
		            "title": "this is menu",
		            "text": "description",
		            "defaultAction": {
		                "type": "uri",
		                "label": "View detail",
		                "uri": "http://example.com/page/222"
		            },
		            "actions": [
		                {
		                    "type": "postback",
		                    "label": "Buy",
		                    "data": "action=buy&itemid=222"
		                },
		                {
		                    "type": "postback",
		                    "label": "Add to cart",
		                    "data": "action=add&itemid=222"
		                },
		                {
		                    "type": "uri",
		                    "label": "View detail",
		                    "uri": "http://example.com/page/222"
		                }
		            ]
		          }
		      ],
		      "imageAspectRatio": "rectangle",
		      "imageSize": "cover"
		  }
		}
	end

end

