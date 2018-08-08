class UsersController < ApplicationController
	before_action :find_user, only: [:show, :update, :destroy]

	def new
		@user = User.new
	end

	def create
		user = User.new(user_params)
		if user.save
			flash[:success] = "Successflly created."
			redirect_to '/signin'
		else
			flash[:error] = "Bad email or password"
			redirect_to '/signup'
		end
	end

	def show
	end

	private
	def find_user
		@user = User.find(params[:id])
	end

	def user_params
		params.require(:user).permit(:email, :password, :password_confirmation)
	end
end
