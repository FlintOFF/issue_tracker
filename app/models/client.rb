class Client < ApplicationRecord
  has_secure_password

  has_many :issues, dependent: :destroy

  # validations
  validates :password_digest, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
