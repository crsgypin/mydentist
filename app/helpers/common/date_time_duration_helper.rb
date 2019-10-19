module Common::DateTimeDurationHelper

	def segments
		[
      {name: "整日", hours: (6..22)},
      {name: "早上", hours: (6..12)},
      {name: "下午", hours: (12..18)},
      {name: "晚上", hours: (18..22)}
    ]
	end

	def segment_hours(k = "整日")
		segments.find do |a|
    	a[:name] == k
    end[:hours]
	end

	def ch_wdays
		@ch_wdays ||= {
			0 => "星期日",
			1 => "星期一",
			2 => "星期二",
			3 => "星期三",
			4 => "星期四",
			5 => "星期五",
			6 => "星期六"
		}
	end

	def ch_wday(wday)
		ch_wdays[wday]
	end	

	def hour_minute_format(hour, minute)
		# "#{hour}:#{sprintf('%02d', minute)}"
		"#{sprintf('%02d', hour)}:#{sprintf('%02d', minute)}"
	end

	def parse_hour_minute_format(str)
		raise "格式錯誤，沒有 : , 原文: #{str}" if !str.include?(":")
		r = {
			hour: str.split(":")[0],
			minute: str.split(":")[1]
		}
	end

	def wday_hour_minute_format(wday, hour, minute)
		hour_minute = hour_minute_format(hour, minute)
		"#{wday}_#{hour_minute}"
	end

	def parse_wday_hour_minute_format(str)
		raise "格式錯誤，沒有 _ , 原文: #{str}" if !str.include?("_")
		wday = str.split("_")[0].to_i
		hour_minute = str.split("_")[1]
		hour = hour_minute[0].to_i
		minute = hour_minute[1].to_i
		r = {
			wday: wday,
			hour: hour,
			minute: minute
		}
		r
	end

end

