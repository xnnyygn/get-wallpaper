class User < ActiveRecord::Base
  validates :name, presence: true, length: {maximum: 255}, uniqueness: true
  has_secure_password
end
