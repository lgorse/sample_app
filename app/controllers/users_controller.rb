class UsersController < ApplicationController
	
	def show
		@user = User.find(params[:id])
		@title = @user.name
	end

	def new
		@title = "Sign up"
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			flash[:success] = "Welcome to the Sample App!"
			sign_in @user
			redirect_to user_path(@user)
			#:flash => { :success => "Welcome to the Sample App"}
		else
			#flash{:success => "Welcome to the Sample App"}
			render 'new'
		end
	end
end
