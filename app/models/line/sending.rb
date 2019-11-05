class Line::Sending < ApplicationRecord
	self.table_name = "line_sendings"
	belongs_to :account
	belongs_to :client_sending, class_name: "Line::Sending", foreign_key: :client_sending_id, optional: true
	has_many :sending_messages
	enum source: {"server" => 1, "client" => 2}
	enum server_type: {"push" => 1, "reply" => 2}
	enum status: {"成功" => 1, "失敗" => 2, "測試" => 3}
	after_create :check_message_source
	validates_presence_of :source
	attr_accessor :reply_token

	def messages=(messages)
		if messages.class.name == "Array"
			messages.each do |message|
				self.sending_messages.new({
					content_json: message
				})
			end
		else
			self.sending_messages.new({
				content_json: messages
			})
		end
	end

	def messages
		self.sending_messages.map do |m|
			m.content_json
		end
	end

	private

	def check_message_source
		if self.source != "server"
			return
		end
		if self.status == "測試"
			return
		end
    linebot ||= Line::Bot::Client.new do |config|
      config.channel_secret = Rails.application.config_for('api_key')["line"]["channel_secret"]
      config.channel_token = Rails.application.config_for('api_key')["line"]["channel_access_token"]
    end

    begin
    if self.server_type == "push"
    	response = linebot.push_message(self.account.line_user_id, self.messages)
    elsif self.server_type == "reply"
    	raise "no reply token for reply" if !self.reply_token.present?
	    response = linebot.reply_message(self.reply_token, self.messages)
    end
    Rails.logger.info "line response, action: #{self.server_type}, code: #{response.code}, body: #{response.body}"

    if response.code.to_i == 200
    	self.update(status: "成功")
    else
    	m = "#{response.code}, #{response.body}"[0..170]
    	self.update(status: "失敗", error_message: m)
    end

	  rescue Exception => e
	  	m = "#{e.to_s}, #{e.backtrace.first(5).join("\n")}"[0..170]
	  	self.update(status: "失敗", error_message: m)
	  end
	end

end
