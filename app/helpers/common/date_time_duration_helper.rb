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
		hour = hour_minute.split(":")[0].to_i
		minute = hour_minute.split(":")[1].to_i
		r = {
			wday: wday,
			hour: hour,
			minute: minute
		}
		r
	end

	def wday_durations_note(wday_durations)
		g_wday_durations = wday_durations.group_by do |a| 
			a.wday
		end.sort do |a, b|
			wday1 = a[0]
			wday2 = b[0]
			wday1 = wday1 == 0 ? 7 : wday1 #sunday to last
			wday2 = wday2 == 0 ? 7 : wday2 #sunday to last
			wday1 - wday2
		end
		all_segments = {}
		g_wday_durations.each do |wday, w_durations|
			w_durations = w_durations.sort{|a,b| (a.hour * 60 + a.minute) - (b.hour * 60 + b.minute)}
			w_segments = []
			all_segments[wday] = w_segments
			segments = nil
			last_w_duration = nil
			w_durations.each do |w_duration|
				if last_w_duration.nil?
					#create new segments
					segments = [w_duration]
					w_segments.push(segments)
				else
					last_time = last_w_duration.hour * 60 + last_w_duration.minute
					cur_time = w_duration.hour * 60 + w_duration.minute
					if last_time + last_w_duration.duration == cur_time
						segments.push(w_duration)
					else
						#create new segments
						segments = [w_duration]
						w_segments.push(segments)
					end
				end
				last_w_duration = w_duration
			end
		end
		all_segments.map do |wday, w_segments|
			cw = ch_wday(wday)
			w_segments_note = w_segments.map do |w_segment|
				"#{w_segment.first.hour_minute} ~ #{w_segment.last.end_hour_minute}"
			end.join(", ")
			"#{cw} #{w_segments_note}"
		end.join("\n")
	end

end

