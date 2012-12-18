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

 before_save :encrypt_password

 def has_password?(submitted_password)
 	self.encrypted_password == encrypt(submitted_password)
 end

 class << self
 	def authenticate(email, submitted_password)
 		user = find_by_email(email)
 		(user && user.has_password?(submitted_password)) ? user : nil

 	end

 	def authenticate_with_salt(id, cookie_salt)
 		user = find_by_id(id)
 		(user && (user.salt == cookie_salt)) ? user : nil

 	end

 end

 private 

 def encrypt_password
 	self.salt = make_salt if new_record?
 	self.encrypted_password = encrypt(self.password)
 end

 def encrypt(string)
 	secure_hash("#{salt}--#{string}")
 end

 def secure_hash(string)
 	Digest::SHA2.hexdigest(string)
 end

 	def make_salt
 		secure_hash("#{Time.now.utc}--#{self.password}")
 	end

end

#larry = User.create!(:name=>"larry", :email => "donald@duck.disney", :password=>"mickey", :password_confirmation=>"mickey")
