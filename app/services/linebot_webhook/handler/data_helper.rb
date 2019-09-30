module LinebotWebhook::Handler::DataHelper

	#for client-side message
	def parse_message_data(event)
		if event["type"] == "message"
			r = {
				type: "message",
				content: event['message']['text']
			}
		elsif event["type"] == "postback"
			r = {
				type: "postback",
				content: proc do 
					data = event['postback']['data']
					r = CGI.parse(data).map{|k,v| [k,v.first]}.to_h.symbolize_keys
				end.call
			}
		elsif event["type"] == "follow"
			r = {
				type: "follow"
			}
		elsif event["type"] == "unfollow"
			r = {
				type: "unfollow"
			}
		end
	end

	#for server-side message
	def convert_reply_message(data, option = {})
		if data[:type] == "text"
			convert_message(data)
		elsif data[:type] == "quick_reply_buttons"
			convert_quick_reply_buttons(data)
		elsif data[:type] == "confirm"
			convert_confirm_template(data)
		elsif data[:type] == "carousel"
			convert_carousel(data)
		else
			raise "invalid type: #{data[:type]}"
		end
	end

	private

	def convert_message(data)
		r = {
      type: 'text',
      text: data[:text]
		}
	end

	def convert_quick_reply_buttons(data)
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

	def convert_confirm_template(data)
		r = {
			type: "template",
			altText: data[:alt_text],
			template: {
				type: "confirm",
				text: data[:text],
				actions: data[:actions]
			}
		}
	end

	def convert_carousel(data)
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
						data: c[:data]
					}
					#convert
					r = {}
					r[:thumbnailImageUrl] = column[:image_url] if column[:image_url].present?
					r[:imageBackgroundColor] = column[:bg_color] || "#FFFFFF"
					r[:title] = column[:title]
					r[:text] = column[:text]
					r[:defaultAction] = column[:default_action]
					r[:actions] = column[:actions]
					r
				end
			}
		}
		Rails.logger.info "carousel: #{r}"
		r
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

