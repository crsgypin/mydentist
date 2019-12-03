class Sys::Holiday < ApplicationRecord
	include HolidayCategoriesConcern

	def self.init_holidays
		[
			{category: "除夕早上", name: "除夕早上", date: "2020/1/23", start_hour: 6, end_hour: 12},
			{category: "除夕下午", name: "除夕下午", date: "2020/1/23", start_hour: 12, end_hour: 18},
			{category: "除夕晚上", name: "除夕晚上", date: "2020/1/23", start_hour: 18, end_hour: 24},
			{category: "初一", name: "初一", date: "2020/1/24", start_hour: 0, end_hour: 24},
			{category: "初二", name: "初二", date: "2020/1/25", start_hour: 0, end_hour: 24},
			{category: "初三", name: "初三", date: "2020/1/26", start_hour: 0, end_hour: 24},
			{category: "初四", name: "初四", date: "2020/1/27", start_hour: 0, end_hour: 24},
			{category: "初五", name: "初五", date: "2020/1/28", start_hour: 0, end_hour: 24},
			{category: "初六", name: "初六", date: "2020/1/29", start_hour: 0, end_hour: 24},
			{category: "國定假日", name: "元旦", date: "2020/1/1", start_hour: 0, end_hour: 24},
			{category: "國定假日", name: "228", date: "2020/2/28", start_hour: 0, end_hour: 24},
			{category: "國定假日", name: "清明節", date: "2020/4/4", start_hour: 0, end_hour: 24},
			{category: "國定假日", name: "勞工節", date: "2020/5/1", start_hour: 0, end_hour: 24},
			{category: "國定假日", name: "端午節", date: "2020/6/25", start_hour: 0, end_hour: 24},
			{category: "國定假日", name: "中秋節", date: "2020/10/1", start_hour: 0, end_hour: 24},
			{category: "國定假日", name: "國慶日", date: "2020/10/10", start_hour: 0, end_hour: 24}
		].each do |r|
			h = Sys::Holiday.find_or_create_by(date: r[:date], start_hour: r[:start_hour], end_hour: r[:end_hour])
			h.update!(category: r[:category], name: r[:name])
		end
	end

end
