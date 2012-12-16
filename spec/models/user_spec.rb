require 'spec_helper'

describe User do 

	before(:each) do
		@attr = {:name => "Example User", :email => "user@example.com"}
	end

	it "should create a new instance given a valid attribute" do
		User.create!(:name => "Example User", :email => "user@Example.com")
	end

	it "should require a name" do
		no_name_user = User.new(@attr.merge(:name => ""))
		no_name_user.should_not be_valid
	end

	it "should require an email address" do
		no_email_user = User.new(@attr.merge(:email=>""))
		no_email_user.should_not be_valid
	end

	it "should reject names that are too long" do
		name = "a" * 51
		name_user = User.new(@attr.merge(:name=> name))
		name_user.should_not be_valid
	end

	it "should accept valid email address" do
		address = "user@test.com"
		valid_email_user = User.new(@attr.merge(:email => address))
		valid_email_user.should be_valid
	end

	it "should reject invalid email addresses" do

		addresses = %w[user@foo,com user_at.foobar.org larry@super.]
		addresses.each do |address|
			valid_email_user = User.new(@attr.merge(:email => address))
		valid_email_user.should_not be_valid
		end
	end

	it "should reject invalid email addresses" do
		User.create!(@attr)
		user_with_duplicate = User.new(@attr)
		user_with_duplicate.should_not be_valid
	end

	it "should reject upcased identical email addresses" do
		address_upcased = @attr[:email].upcase
		User.create!(@attr.merge(:email => address_upcased))
		user_with_duplicate = User.new(@attr)
		user_with_duplicate.should_not be_valid
	end
end