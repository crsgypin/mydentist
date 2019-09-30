module Linebot::Clinics::Webhook::Helper::ClientMessageHelper

	#for client-side message
	def parse_client_message(event)
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

end
