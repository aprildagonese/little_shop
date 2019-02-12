class User < ApplicationRecord
  has_many :orders#, dependent: :destroy
  has_many :items

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates_presence_of :password, require: true
  #validates :password_confirmation, presence: true

  has_secure_password

  enum role: [:registered, :merchant, :admin]
  enum activation_status: [:active, :inactive]
end
