require 'spec_helper'

describe "Users" do
	describe "signup" do
		describe "failure" do 
			it "should not create a new user" do
				lambda  do
					visit signup_path
					fill_in "Name",			:with => ""
					fill_in "Email", 		:with => ""
					fill_in "Password", 	:with => ""
					fill_in "Confirmation",	:with => ""
					click_button "Sign up"
					#response.should render_template('users/new')
					#current_path.should render_template ('users/new')
					#response.should have_selector('div#error_explanation')
				end.should_not change(User, :count)
			end
		end
	end
end
