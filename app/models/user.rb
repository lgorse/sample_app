class User < ActiveRecord::Base
	attr_accessor :password
  attr_accessible :email, :name, :password, :password_confirmation

email_format = /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, :presence=> true, :length => {:maximum => 45}
  validates :email, :presence=>true, 
					:format => {:with=> email_format},
					:uniqueness => {:case_sensitive => false}
	validates :password, :presence => true,
						 :confirmation => true,
						 :length => {:within =>6..40}

end
