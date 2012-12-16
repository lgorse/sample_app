require 'spec_helper'

describe User do 

	before(:each) do
		@attr = {:name => "Example User", 
				:email => "user@example.com", 
				:password => "secret",
				:password_confirmation=>"secret"}
	end

	it "should create a new instance given a valid attribute" do
		User.create!(:name => "Example User", :email => "user@Example.com", :password=>"secret")
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

	describe "password" do

		before(:each) do
			@user = User.new(@attr)
		end
		it "should have a password attribute" do
			@user.should respond_to(:password)
		end

		it "should have a password confirmation attribute" do
			@user.should respond_to(:password_confirmation)
		end

		describe "password validation" do
			it "should require a password" do
				User.new(@attr.merge(:password=>"", :password_confirmation=>"")).should_not be_valid
			end

			it "should requie a password confirmation" do
				User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
			end

			it "should reject short passwords" do
				short = "a"*5
				hash = @attr.merge(:password=>short, :password_confirmation=>short)
				User.new(hash).should_not be_valid
			end

			it "should reject long passwords" do
				long = "a" * 41
				hash = @attr.merge(:password=>long, :password_confirmation=>long)
				User.new(hash).should_not be_valid
			end
		end

		describe "password encryption" do

			before(:each) do
				@user = User.create!(@attr)
			end

			it "should have an encrypted password attribute" do
				@user.should respond_to(:encrypted_password)
			end

			it "should set the encrypted password attribute" do
				@user.encrypted_password.should_not be_blank
			end

			it "should have a salt" do
				@user.should respond_to(:salt)
			end
		end

	describe "has_password? method"do

		it "should exist" do
			@user.should respond_to(:has_password?)
		end

		it "should return true if the passwords match" do
			@user.has_password(@attr[:password]).should be_true
		end

		it "should return false if passwords don't match" do
			@user.has_password("invalid").should be_false
		end
	end

	describe "authenticate method" do

		it "should exist" do
			User.should respond_to(:authenticate)
		end

		it "should return nil on email/password mismatch" do
			User.authenticate(@attr[:email], "wrong").should be_nil
		end

		it "should return nil on email address with no user" do
			User.(@attr[:password], "wrong@nottrue.false").should be_nil
		end

		it "should rreturn the valid user" do
			User.authenticate(@attr[:email], @attr[:password]).should == @user
		end
	end



	end

end