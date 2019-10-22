class Admin::ApplicationController < ApplicationController
  layout 'admin'

  include JsCrudConcern

  def search_doctor_durations
  	@s = params[:s] || {}
  	if @s[:wday].present?
  		@doctor_durations = @doctor_durations.where(wday: @s[:wday])
  	end
  end

end