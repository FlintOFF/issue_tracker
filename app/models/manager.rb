class Manager < ApplicationRecord
  has_secure_password

  has_many :issues

  # validations
  validates :email, uniqueness: { case_sensitive: false }, presence: true
  validates :password_digest, presence: true
end
