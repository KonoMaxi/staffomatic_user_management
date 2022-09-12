class User < ApplicationRecord
  audited only: :archived, on: [:update, :destroy]
  has_secure_password

  validates :email,
    presence: true,
    uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
