class User < ApplicationRecord
  has_many :orders#, dependent: :destroy
  has_secure_password

  validates :name, presence: true, uniqueness: true
  #validates :username, presence: true, uniqueness: true
  #validates :password, presence: true, uniqueness: true

  enum role: %w(default visitor)
end
