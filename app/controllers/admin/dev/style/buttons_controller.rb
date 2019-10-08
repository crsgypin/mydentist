class Admin::Dev::Style::ButtonsController < Admin::Dev::Style::ApplicationController

	
	def index
		@buttons = buttons
	end

	private

	def buttons
		file = File.read("app/assets/stylesheets/resets/buttons.scss")
		buttons_strs = file.split("\n").select{|a| a.include?(".") && a.include?("{")}
		buttons = buttons_strs.map do |a| 
			class_name = a.gsub(/\.| |{|/,"")
			r = {
				class_name: class_name
			}
		end
	end

end

