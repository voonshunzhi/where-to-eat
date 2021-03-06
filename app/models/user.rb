class User < ApplicationRecord
	has_secure_password
	has_many :authentications, dependent: :destroy

	validates :email, format: { with: /\A\w+.?\w+@\w+.\w+\z/ }, uniqueness: true
  	validates :password, on: :create, presence: {message: "Password cannot be blank"}, length: {minimum: 8}

	def self.create_with_auth_and_hash(authentication, auth_hash)
		user = self.create!(
			email: auth_hash["info"]["email"],
			password: SecureRandom.hex(10)
		)
		user.authentications << authentication
		return user
	end

	# grab google to access google for user data
	def google_token
		x = self.authentications.find_by(provider: 'google_oauth2')
		return x.token unless x.nil?
	end
end
