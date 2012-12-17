require 'factory_girl'

FactoryGirl.define do
	factory :user do |user|
		user.name "New user"
		user.email "newExample@trial.com"
		user.password "mypassword"
		user.password_confirmation "mypassword"
	end
end

