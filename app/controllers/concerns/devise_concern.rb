module DeviseConcern

	def after_sign_in_path_for(member)
		clinic_events_path(member.clinic)
	end

  def after_sign_out_path_for(resource_or_scope)
    member_session_path
  end	

end