module PathConcern
	extend ActiveSupport::Concern
  included do
	  helper_method :member_root_path
	  helper_method :base_domain
  end

	def admin_boss_root_path
		admin_boss_videos_path
	end

	def member_root_path(member)
		# member_created_posts_path(member)
		# edit_member_profile_path(member)
		main_profile_path(member)
	end

	def base_domain
		Rails.application.config_for(:api_key)["base_domain"]
	end

end

