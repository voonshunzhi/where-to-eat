class SessionsController < ApplicationController
	def new
	end

	def create 
		user = User.find_by_email(params[:email])
		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect_to user_path(user)
		else
			redirect_to '/signin'
		end
	end

	def destroy
		session[:user_id] = nil
		redirect_to '/signin'
	end

	def create_from_omniauth
		auth_hash = request.env["omniauth.auth"]
		authentication = Authentication.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"]) ||  Authentication.create_with_omniauth(auth_hash)

		# if: previously already logged in with OAuth
		if authentication.user
			user = authentication.user
			authentication.update_token(auth_hash)
			@next = user_path(user)
			@notice = "Signed in!"
		# else: user logs in with OAuth for the first time
		else
			user = User.create_with_auth_and_hash(authentication, auth_hash)
			# you are expected to have a path that leads to a page for editing user details
			@next = user_path(user)
			@notice = "User created. Please confirm or edit details"
		end

		session[:user_id] = user.id
		redirect_to @next, :notice => @notice
	end
end
