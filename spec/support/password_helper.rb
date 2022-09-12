require "bcrypt"

module PasswordHelper
  def password_one_digest
    BCrypt::Password.create(password_one)
  end

  def password_one
    "password"
  end

  def password_two_digest
    BCrypt::Password.create(password_two)
  end

  def password_two
    "supersecurepassword"
  end

  def generate_token user
    return JwtAuthenticationService.encode_token({ user_id: user.id })
  end
end