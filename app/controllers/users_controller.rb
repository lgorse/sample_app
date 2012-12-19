class UsersController < ApplicationController

	before_filter :authenticate, :only => [:edit, :update, :index]
	before_filter :correct_user, :only => [:edit, :update]
	
	def index
		@title = 'User index'
		@users = User.paginate(:page => params[:page])
	end

	def show
		@user = User.find(params[:id])
		@title = @user.name
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
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			flash[:success] = "User information updated"
			redirect_to @user
		else
			@title = 'Edit user'
			render 'edit'
		end
	end

	private

	def authenticate
		deny_access unless signed_in?
	end

	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_path) unless @user == current_user
	end

	
end
