class Clinic::Notification < ApplicationRecord
	belongs_to :clinic
	belongs_to :patient
	init_categories = proc do
	  enum category: self.category_contents.map{|a| [a[:category], a[:index]]}.to_h
	end
	json_format :args

	def content
		e = self.class.category_contents.find{|a| a[:category] == self.category}
		c = c[:content]
		c[:args].each do |key, value|
			c = c.gsub("{#{key}}", value)
		end
		c
	end

	def self.category_contents
		[
			{
				category: "已綁定",
				index: 1,
				title: "已綁定成功",
				content: "{date}",
				args: {
					date: "日期時間"
				}
			},			
			{
				category: "已預約",
				index: 2,
				title: "已預約掛號",
				content: "{doctor_name} {date} {service_name}",
				args: {
					doctor_name: "醫生名稱",
					date: "日期",
					service_name: "診療項目"
				}
			},			
			{
				category: "回覆同意",
				index: 3,
				title: "已變更",
				content: "看診時間至{date}",
				args: {
					doctor_name: "醫生名稱",
					date: "日期",
					service_name: "診療項目"
				}
			},
			{
				category: "回覆取消",
				index: 4,
				title: "取消回覆",
				content: "{date}",
				args: {
					date: "日期時間"
				}
			},
		]
	end

	init_categories.call
end
