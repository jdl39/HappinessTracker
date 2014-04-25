class User < ActiveRecord::Base
	has_many :activities

	validates :username, presence: true, uniqueness: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
	validates :first_name, presence: true
	validates :last_name, presence: true

	before_save { self.email = email.downcase }

	before_create :create_remember_token

	# When saving a user, include a password and password_confirmation field (must be equal). They are automatically hashed.
	# When authenticating a user, call user.authenticate(password), which will ensure that the password corresponds to the hash.
	has_secure_password

	def User.new_remember_token
    	SecureRandom.urlsafe_base64
  	end

  	def User.digest(token)
    	Digest::SHA1.hexdigest(token.to_s)
  	end

	private
		def create_remember_token
			self.remember_token = User.digest(User.new_remember_token)
		end
end
