module UsersHelper
	def current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end

	def authenticate
		redirect_to '/signin' unless current_user
	end
end
