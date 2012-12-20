#require 'factory_girl'

FactoryGirl.define do
	factory :user do |user|
		user.name "New user"
		user.email "newExample@trial.com"
		user.password "mypassword"
		user.password_confirmation "mypassword"
	end
end

FactoryGirl.define do
	factory :micropost do |micropost|
		micropost.content		"Hello, world"
		micropost.association	:user
	end
end



