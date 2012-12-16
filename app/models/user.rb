class User < ActiveRecord::Base
  attr_accessible :email, :name

email_format = /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, :presence=> true, :length => {:maximum => 45}
  validates :email, :presence=>true, 
					:format => {:with=> email_format},
					:uniqueness => {:case_sensitive => false}

end
