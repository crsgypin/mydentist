class BookingEvent < ApplicationRecord
	#booking_event 為預約中的event, 分開來目的是希望Event的規則可以確定
	belongs_to :clinic
	belongs_to :line_account, class_name: "Line::Account", foreign_key: :line_account_id, optional: true
	belongs_to :patient, optional: true
	belongs_to :doctor, optional: true
	belongs_to :service, optional: true
	belongs_to :event, optional: true
end
