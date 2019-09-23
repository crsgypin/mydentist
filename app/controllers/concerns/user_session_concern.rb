module UserSessionConcern

	def check_user_session
		#check time
		current_time = Time.now
		last_time = Time.parse(session[:last_updated_at]) rescue Time.now
		if (current_time - last_time).seconds > 15.minutes
			session[:user_id] = nil
		end
		session[:last_updated_at] = current_time

		#check user_id
		if session[:user_id].nil?
			user_id = "u#{rand(10**20)}"
			UserSession.create(session_id: user_id, member: current_member)
			session[:user_id] = user_id
			@current_user_session_id = session[:user_id]
		end
	end

	def current_user_session_id
		@current_user_session_id ||= session[:user_id]
	end


end

