class User < ActiveRecord::Base
	has_many :activities

	validates :username, presence: true, uniqueness: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
	validates :first_name, presence: true
	validates :last_name, presence: true

	before_save { self.email = email.downcase }

	# When saving a user, include a password and password_confirmation field (must be equal). They are automatically hashed.
	# When authenticating a user, call user.authenticate(password), which will ensure that the password corresponds to the hash.
	has_secure_password
end
