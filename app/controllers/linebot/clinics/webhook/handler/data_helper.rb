module Linebot::Clinics::Webhook::Handler::DataHelper

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
								data: item[:data].to_query,
								displayText: item[:name]
							}      			
	      		}
	      	end
	      }
			}
	end

	def convert_carousel(data)
		r = {
			type: "template",
			altText: data[:title],
			template: {
				type: "carousel",
				columns: data[:columns].map do |c|
					column = {
						image_url: c[:image_url],
						bg_color: c[:bg_color],
						title: c[:title],
						name: c[:name],
						data: c[:data]
					}
					#convert
					r = {}
					r[:thumbnailImageUrl] = column[:image_url] if column[:image_url].present?
					r[:imageBackgroundColor] = column[:bg_color] || "#FFFFFF"
					r[:title] = column[:title]
					r[:actions] = {
						typee: "postback",
						label: item[:name],
						data: item[:data].to_json
					}
					r
				end
			}
		}
	end

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


end

