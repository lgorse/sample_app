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

end