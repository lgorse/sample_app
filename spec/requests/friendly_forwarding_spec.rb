require 'spec_helper'

describe "FriendlyForwardings" do
	it "should forward to the requested page after signin" do
		user = FactoryGirl.create(:user)
		visit edit_user_path(user)
		fill_in "Email", :with => user.email
		fill_in "Password", :with => user.password
		click_button "Update"
		#page.should render_template('user/edit')
		#current_path.should == edit_user_path
		#expect(response).to render_template('users/edit')
	end
	
end