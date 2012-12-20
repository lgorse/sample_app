require 'spec_helper'

describe UsersController do
	render_views

	describe "GET 'index'" do

		describe "for non-signed-in users" do

			it 'should deny access' do
				get :index
				response.should redirect_to(signin_path)
			end
		end

		describe "for signed-in users" do

			before(:each) do
				@user = FactoryGirl.create(:user)
				FactoryGirl.create(:user, :email =>"other@email.com")
				FactoryGirl.create(:user, :email =>"yetAnother@email.com")
				test_sign_in(@user)
			end

			it "should be successful" do
				get :index
				response.should be_success
			end

			it "should have the right title" do
				get :index
				response.body.should have_selector('h1', :text => "User index")
			end

			it "should have an element for each user" do
				get :index
				User.paginate(:page=>1).each {|user| response.body.should render_template('user')}
			end

			it "should paginate users" do
				get :index
				#response.body.should have_selector('div.container')
				#response.body.should have_selector('span.disabled', :text =>'Previous')
				#response.body.should have_selector('a', :href => '/users?page=2', :text => '2')
			end

			it "should have delete links for admins" do
				@user.toggle!(:admin)
				other_user = User.all.second
				get :index
				response.body.should have_link('delete', href: user_path(other_user))
				#user_path(other_user)
			end
		end
	end

	describe "DELETE 'destroy'" do

		before(:each) do
			@user = FactoryGirl.create(:user)
		end

		describe "as a non-signed-in user" do

			it "should deny access" do
				delete :destroy, :id => @user
				response.should redirect_to(signin_path)
			end
		end

		describe "as non-admin user" do

			it "should protect the action" do
				test_sign_in(@user)
				delete :destroy, :id => @user
				response.should redirect_to(root_path)
			end
		end

		describe "as an admin user" do
			before(:each) do
				@admin = FactoryGirl.create(:user, :email => "newadmin@admin.com", :admin => true)
				test_sign_in(@admin)
			end

			it "should destroy the user" do
				lambda do
					delete :destroy, :id => @user
				end.should change(User, :count).by(-1)

			end

			it "should redirect to the users page" do
				delete :destroy, :id => @user
				response.should redirect_to(users_path)
			end

			it "should not let the admin user destroy himself" do
				lambda do
					delete :destroy, :id => @admin
				end.should_not change(User, :count)
			end
		end
	end

	describe "GET 'show'" do

		before(:each) do
			@user = FactoryGirl.create(:user)
			@mp1 = FactoryGirl.create(:micropost, :user => @user, :created_at => 1.day.ago)
			@mp2 = FactoryGirl.create(:micropost, :user => @user, :content => "marty pants", :created_at => 1.hour.ago)
		end

		it "should be successful" do
			get :show, :id=>@user
			response.should be_success
		end

		it "should find the right user" do
			get :show, :id =>@user
			assigns(:user).should == @user
		end

		it "should render the correct partial" do
			get :show, :id => @user
			response.should render_template('micropost')
		end

		it "should show the user's microposts" do
			get :show, :id=>@user
			response.body.should have_selector('span.content', :text => @mp1.content)
			response.body.should have_selector('span.content', :text => @mp2.content)
		end

		it "should paginate microposts" do
			30.times {FactoryGirl.create(:micropost, :user => @user, :content => "foo")}
			get :show, :id=>@user
			response.body.should have_selector('div.pagination')
			response.body.should have_selector('span.disabled', :text =>'Previous')
		end

		it "should provide the micropost count" do
			30.times {FactoryGirl.create(:micropost, :user => @user, :content => "foo")}
			get :show, :id => @user
			response.body.should have_selector('td.sidebar', :text => @user.microposts.count.to_s)

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


		describe "success" do

			before(:each) do
				@attr = {:name => "New User", :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar"}
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
				controller.should be_signed_in
			end
		end
	end

	describe "GET 'edit'" do

		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
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
			test_sign_in(@user)
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

	describe "authentification of edit/update actions" do

		before (:each) do
			@user = FactoryGirl.create(:user)
		end

		describe "for non-signed-in users" do

			it "should deny access to 'edit'" do
				get :edit, :id => @user
				flash[:notice].should =~ /Sign in/i
				response.should redirect_to(signin_path)
			end

			it "should deny access to 'update'" do
				get :update, :id => @user
				flash[:notice].should =~ /Sign in/i
				response.should redirect_to(signin_path)
			end

		end

		describe "for signed-in users" do

			before(:each) do
				wrong_user = FactoryGirl.create(:user, :email => "user@example.net")
				test_sign_in(wrong_user)
			end

			it "should require matching users for 'edit'" do
				get :edit, :id => @user
				response.should redirect_to(root_path)
			end

			it "should require matching users for 'update'" do
				put :update, :id => @user, :user => {}
				response.should redirect_to(root_path)
			end
		end
	end
end
