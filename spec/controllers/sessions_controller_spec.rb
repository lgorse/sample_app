require 'spec_helper'

describe SessionsController do
	render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
    	get :new
    	response.body.should have_selector('h2', :text => 'Sign in')
    end
  end

  describe "Post 'create' session" do

    describe "failure" do

      before (:each) do
        @attr = {:email => "", :password =>""}
      end

      it "should re-render the new page" do
        post :create, :session => @attr
        response.should render_template('new')
      end

      it "should have an error message" do
        post :create, :session =>@attr
        flash.now[:error].should =~ /invalid/i
      end
    end

  end

  describe "success" do

    before (:each) do
      @user = FactoryGirl.create(:user)
      @attr = {:email => @user.email, :password => @user.password}
    end

    it "should sign the user in" do
      post :create, :session =>  @attr
     controller.current_user.should == @user
     controller.should be_signed_in
    end

    it "should redirect to the user show page" do
      post :create, :session => @attr
      response.should redirect_to(user_path(@user))
    end

  end

end
