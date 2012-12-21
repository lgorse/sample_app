require 'spec_helper'

describe "Microposts" do

	before (:each) do
		user = FactoryGirl.create(:user)
		visit signin_path
		fill_in :session_email, :with => user.email
		fill_in :session_password, :with =>user.password
		click_button "Sign in"
	end

	describe "creation" do

		describe "failure" do

			it "should not make a new micropost" do
				lambda do
					visit root_path
					fill_in :micropost_content, :with => ""
					click_button "Submit"
					page.should have_css('table .micropost')
				end.should_not change(Micropost, :count)
			end
		end

		describe "success" do

			it "should make a new micropost" do
				content = "Lorem ipsum"
				lambda do
					visit root_path
					fill_in :micropost_content, :with => content
					click_button "Submit"
					page.should have_content(content)
				end.should change(Micropost, :count).by(1)
			end
		end
	end
  
end
