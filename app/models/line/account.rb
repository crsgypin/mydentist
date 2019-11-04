class Line::Account < ApplicationRecord
	self.table_name = "line_accounts"
	belongs_to :clinic, optional: true #temporarily optional
	belongs_to :patient, optional: true
	has_many :events, class_name: "Event", foreign_key: :line_account_id
	has_many :booking_events, class_name: "BookingEvent", foreign_key: :line_account_id
	has_many :sendings
	enum status: {"follow" => 1, "unfollow" => 2}
	enum dialog_status: {"預約掛號" => 1, "填寫個人資料" => 2}
	validates_presence_of :line_user_id
	before_save :get_and_set_profle_for_validation
	before_save :check_reply_token
	# after_create :create_or_update_richmenu_to_user #over 1000, so depreciated at 2019/7/4
	include ApplicationHelper

	def get_and_set_profle_for_validation
		if self.status == "follow"
			r = get_profile
			self.display_name = r[:display_name]
			self.picture_url = r[:picture_url]
			self.status_message = r[:status_message]
		end
		true
	end

	def get_profile
		begin
			client = Line::Bot::Client.new do |config|
			  config.channel_secret = Rails.application.config_for(:api_key)["line"]["channel_secret"]
			  config.channel_token = Rails.application.config_for(:api_key)["line"]["channel_access_token"]
			end
		  response = client.get_profile(self.line_user_id)
			result = JSON.parse(response.body)
			r = {
				display_name: result["displayName"],
				picture_url: result["pictureUrl"],
				status_message: result["statusMessage"]
			}
		rescue
			r = {
				display_name: "",
				picture_url: "",
				status_message: ""	
			}
		end
	end

	def create_or_update_richmenu_to_user
		_create_or_update_richmenu_to_user
	end

	def get_richmenu_info
		_get_richmenu_info
	end

	def remove_richmenu
		_remove_richmenu
	end

	def check_reply_token
		if changes[:reply_token].present? && self.reply_token.present?
			self.reply_token_time = Time.now
		end
		true
	end

	def push_message(message_content)
		_push_message(message_content)
	end

	private	

  def _push_message(message_content)
    client = Line::Bot::Client.new do |config|
      config.channel_secret = Rails.application.config_for(:api_key)["line"]["channel_secret"]
      config.channel_token = Rails.application.config_for(:api_key)["line"]["channel_access_token"]
    end
    message = {
      type: 'text',
      text: message_content
    }
    response = client.push_message(self.line_user_id, message)
    Rails.logger.info "naver_line_push_log, line_user_id: #{line_user_id}, message: #{message_content}.\n result: code: #{response.code}, body: #{response.body}"
    result = {
      result: true,
      response: {
        code: response.code,
        body: response.body
      }
    }
  end	

end
