module Common::StringHelper

	def short_string(s, length)
		s = s || ""
		if s.length < length
			s
		else
			"#{s[0..length]}..."
		end
	end

	def number_comma(number)
		if number.present?
			number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
		else
			nil
		end
	end

end

