# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  default_scope :order => 'microposts.created_at DESC'

  validates :user_id, :presence=> true
  validates :content, :length => {:within => 1..140}, :presence => true
end
