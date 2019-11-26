module Common::DateHelper
	include Common::DateTimeDurationHelper

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
			elsif type == 3
				time_now = Time.now.to_i
				delta = time_now - datetime.to_i
				if delta < 3600
					"#{(delta.to_f/60).ceil}#{I18n.locale == :"zh-TW" ? "分鐘前" : " mins ago"}"
				elsif delta < 24 * 3600
					"#{(delta/3600).floor}#{I18n.locale == :"zh-TW" ? "小時前" : " hours ago"}"
				elsif delta < 30 * 24 * 3600
					"#{(delta/24/3600).floor}#{I18n.locale == :"zh-TW" ? "天前" : " days ago"}"
				elsif delta	< 365 * 24 * 3600
					"#{(delta/30/24/3600)}#{I18n.locale == :"zh-TW" ? "個月前" : " months ago"}"
				elsif delta < 10 * 365 * 24 * 3600
					"#{(delta/365/24/3600)}#{I18n.locale == :"zh-TW" ? "年前" : " years ago"}"
				else
					"#{datetime.year}/#{datetime.month}/#{datetime.day}"
				end
			end
		else
			""
		end
	end

	def roc_format(date, format=1)
		return nil if date.nil?
		if format == 1
			# 82年10月15日
			"#{date.year - 1911}年#{date.month}月#{date.day}日"
		elsif format == 2
			# ch_wday = ["日", "一", "二", "三", "四", "五", "六"]
			# 民國82年10月15日
			"民國#{date.year - 1911}年#{date.month}月#{date.day}日(#{ch_wday(date.wday)})"
		elsif format == 3
			# 108/2/3
			"#{date.year - 1911}/#{date.month}/#{date.day}"
		elsif format == 4
			# 108/2/3 (週ㄧ)
			"#{date.year - 1911}/#{date.month}/#{date.day} (#{ch_wday(date.wday)})"
		elsif format == 5
			# 108/2/3 18:10
			datetime = date
			hour = datetime.hour < 10 ? "0#{datetime.hour}" : "#{datetime.hour}"
			minute = datetime.min < 10 ? "0#{datetime.min}" : "#{datetime.min}"
			"#{datetime.year - 1911}/#{datetime.month}/#{datetime.day} #{hour}:#{minute}"
		end
	end

	def roc_year(date)
		return nil if date.nil?
		(date.year - 1911)
	end

end