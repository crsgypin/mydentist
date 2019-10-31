class Admin::Dev::Style::ComponentsController < Admin::Dev::Style::ApplicationController
	
	def index
		@components = components
	end

	def show
		@component = components.find{|c| c[:key] == params[:id]}
	end


	private

	def components
		components = [
			{key: "linechat", name: "LINE聊天"}
		]
	end

end

