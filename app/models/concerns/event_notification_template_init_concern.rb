module EventNotificationTemplateInit

	extend ActiveSupport::Concern
  included do
  	attr_accessor :text_message
		after_create :send_message

  end

end

