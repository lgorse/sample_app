require 'spec_helper'

describe UsersController do
	render_views

	describe "GET 'show'" do

		before(:each) do
			@user = FactoryGirl.create(:user)
		end

		it "should be successful" do
			get :show, :id=>@user
			response.should be_success
		end

		it "should find the right user" do
			get :show, :id =>@user
			assigns(:user).should == @user
		end
	end

	describe "GET 'new'" do
		before(:each) do
			@user = FactoryGirl.create(:user)
		end

		it "should log the user out" do
			get :new, :id => @user
			controller.should_not be_signed_in
		end

	end

	describe "POST 'create'" do

		describe "failure" do

			before(:each) do
				@attr = {:name =>"", :email=>"", :password=>"", :password_confirmation =>""}
			end

			it "should render the 'new' page" do
				post :create, :user => @attr
				response.should render_template('new')
			end

			it "should not create a user" do
				lambda do
					post :create, :user => @attr
				end.should_not change(User, :count)
			end
		end
	end

	describe "success" do

		before(:each) do
			@attr = {:name => "New User", :email => "user@example.com", 
					 :password => "foobar", :password_confirmation => "foobar"}
		end

		it "should create a user" do
			lambda do
				post :create, :user => @attr
			end.should change(User, :count).by(1)
		end

		it "should redirect the user to the user show page" do
			post:create, :user=> @attr
			response.should redirect_to(user_path(assigns(:user)))
		end

		it "should have a welcome message" do
			post:create, :user => @attr
			flash[:success].should =~ /welcome to the sample app/i
		end

		it "should sign user in" do
			post:create, :user =>@attr
			#@user = assigns(:user)
			controller.should be_signed_in
			#response.should redirect_to(user_path(@user))
		end
	end

	describe "GET 'edit'" do

		before(:each) do
			@user = FactoryGirl.create(:user)
		end

		it "should be successful" do
			get :edit, :id => @user
			response.should be_success
		end

		it "should have the right title" do
			get :edit, :id => @user
			response.body.should have_selector('h1', :text => 'Edit user')
		end

		it "should have a link to change the Gravatar" do
			get :edit, :id => @user
			response.body.should have_link('a', :href => 'http://gravatar.com/emails',
													:text => 'Change')
		end
	end

	describe "PUT 'update'"  do

		before(:each) do
			@user = FactoryGirl.create(:user)
		end

		describe "failure" do

			before(:each) do
				@attr = {:name =>"", :email=>"", :password=>"", :password_confirmation =>""}
			end

			it "should render edit page" do
				put :update, :id => @user, :user => @attr
				response.body.should render_template('edit')
			end

			it "should have the right title" do
				put :update, :id => @user, :user => @attr
				response.body.should have_selector('h1', :text => 'Edit user')
			end
		end

		describe "success" do
			before(:each) do
				@attr = {:name =>"New Name", :email=>"user@super.example", :password=>"barbaz", :password_confirmation =>"barbaz"}
			end

			it "should change the user's attributes" do
				put :update, :id => @user, :user => @attr
				user = assigns(:user)
				@user.reload
				user.name.should == @user.name
				user.email.should == @user.email
			end

			it "should have a flash message" do
				put :update, :id => @user, :user => @attr
				flash[:success].should =~ /updated/i
			end
		end

	end
end
=begin
	it "should have the right title" do
		get :show, :id => @user
		response.should have_selector('h2', :content =>@user.name)
	end

	it "should have the user's name" do
		get :show, :id => @user
		response.should have_selector('h2', :content => @user.name)
	end

	it "should have a profile image" do
		get :show, :id => @user
		response.should have_selector('h2>img', :class =>"gravatar")
	end
=end

