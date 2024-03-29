class UsersController < ApplicationController

	before_filter :authenticate, :only => [:edit, :update, :index, :destroy]
	before_filter :correct_user, :only => [:edit, :update]
	before_filter :admin_user, :only => [:destroy]
	
	def index
		@title = 'User index'
		@users = User.paginate(:page => params[:page])
	end

	def show
		@user = User.find(params[:id])
		@title = @user.name
		@microposts = @user.microposts.paginate(:page => params[:page])
	end

	def new
		sign_out
		@title = "Sign up"
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			flash[:success] = "Welcome to the Sample App!"
			sign_in @user
			redirect_to user_path(@user)
		else
			render 'new'
		end
	end

	def edit
		@title = 'Edit user'
	end

	def update
		if @user.update_attributes(params[:user])
			flash[:success] = "User information updated"
			redirect_to @user
		else
			@title = 'Edit user'
			render 'edit'
		end
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User profile destroyed"
		redirect_to(users_path)
	end

	private

	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_path) unless @user == current_user
	end

	def admin_user
		user = User.find(params[:id])
		redirect_to root_path unless (current_user.admin? && current_user!=user)
	end

	
end
