module Common::DateHelper

	def datetime_format(datetime, type = 1)
		if datetime.present?
			if type == 1
				@time_now ||= Time.now.to_i
				delta = @time_now - datetime.to_i
				if delta < 3600
					"#{delta.ceil / 60}#{"分鐘前"}"
				elsif delta < 24 * 3600
					"#{(delta/3600).floor}#{"小時前"}"
				elsif delta < 10 * 24 * 3600
					"#{(delta/24/3600).floor}#{"天前"}"
				# elsif delta	< 365 * 24 * 3600
				# 	"#{(delta/30/24/3600)}#{"個月前"}"
				# elsif delta < 10 * 365 * 24 * 3600
				# 	"#{(delta/365/24/3600)}#{"年前"}"
				else
					"#{datetime.year}/#{datetime.month}/#{datetime.day}"
				end				
			elsif type == 2
				datetime.strftime('%Y/%m/%d %X')
			end
		else
			""
		end
	end

	def hour_minute_format(hour, minute)
		"#{hour}:#{sprintf('%02d', minute)}"
	end

end