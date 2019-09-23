module Common::RenderHelper

	def render_relative_partial(relative_path, option={})
		caller_pathes = caller[0].split(".")[0].split("/")[0..-2]

		r_pathes = []
		relative_path.split("/").each do |a|
			if a.present?
				if a == ".."
					caller_pathes = caller_pathes[0..-2]
				else
					r_pathes << a
				end
			end
		end

		caller_path = caller_pathes.join("/").gsub("#{Rails.root.to_s}/app/views/","")
	  path =  File.join(caller_path, r_pathes.join("/"))

	  option[:partial] = path
	  render option
	end	


end