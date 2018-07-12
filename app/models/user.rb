class User < ApplicationRecord
  self.abstract_class = true

  has_secure_password

  # validations
  validates :email, uniqueness: { case_sensitive: false }, presence: true
  validates :password_digest, presence: true
end
