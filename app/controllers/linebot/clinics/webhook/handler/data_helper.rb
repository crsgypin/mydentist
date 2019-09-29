module Linebot::Clinics::Webhook::Handler::DataHelper

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
					r = JSON.parse(data).symbolize_keys rescue {}
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

	def convert_message(message)
		r = {
      type: 'text',
      text: message
		}
	end

	def convert_postback_buttons(data)
		{
      type: "text",
      text: data[:text],
      quickReply: {
      	items: data[:items].map do |item|
      		r = {
						type: "action",
						action: {
							type: "postback",
							label: item[:name],
							data: item[:data].to_json,
							displayText: item[:name]
						}      			
      		}
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

