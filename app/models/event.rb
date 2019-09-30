class Event < ApplicationRecord
	belongs_to :clinic
	belongs_to :line_account, class_name: "Line::Account", optional: true
	belongs_to :patient, optional: true
	belongs_to :doctor, optional: true
	enum status: {"預約中" => 5, "已預約" => 10, "報到" => 15, "預約中取消" => 40, "已預約取消" => 45, "爽約" => 50, "過期" => 55}

end
