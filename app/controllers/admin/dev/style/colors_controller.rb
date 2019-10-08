class Admin::Dev::Style::ColorsController < Admin::Dev::Style::ApplicationController
	
	def index
		@colors = colors
	end


	private

	def colors
		file = File.read("app/assets/stylesheets/resets/colors.scss")
		colors_strs = file.split("\n").select{|a| a[0..5] == "$color" && a.include?(";")}
		colors = colors_strs.map do |c|
			s = c.split(":")
			r = {
				key: s[0].gsub(/\$| /,""),
				rgb: s[1].gsub(/;| /,"")
			}
		end
		colors
	end

end

