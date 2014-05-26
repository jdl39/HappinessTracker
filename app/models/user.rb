class User < ActiveRecord::Base
  has_many :activities
    has_many :friends
    has_many :users, :source => :friend, :through => :friends
    has_many :happiness_responses
    has_many :comments

    has_and_belongs_to_many :readable_comments, class_name: "Comment", :join_table => :comment_readers
    has_and_belongs_to_many :readable_responses, class_name: "Response", :join_table => :response_readers
    has_and_belongs_to_many :down_comments, class_name: "Comment", :join_table => :comment_down_voters
    has_and_belongs_to_many :up_comments, class_name: "Comment", :join_table => :comment_up_voters
    has_and_belongs_to_many :down_responses, class_name: "Response", :join_table => :response_down_voters
    has_and_belongs_to_many :up_responses, class_name: "Response", :join_table => :response_up_voters

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

	attr_accessor :request_id

	def User.new_remember_token
    	SecureRandom.urlsafe_base64
  	end

  	def User.digest(token)
    	Digest::SHA1.hexdigest(token.to_s)
  	end

  	def happiness_score
  		return happiness_score_for_category_at_time(nil, Time.now)
  	end

  	def happiness_score_at_time(time)
  		return happiness_score_for_category_at_time(nil, time)
  	end

  	def happiness_score_for_category(category)
  		return self.happiness_score_for_category_at_time(category, Time.now)
  	end

    def log_new_measurement(activity, measurement_type, value)
      measurement = Measurement.new
      measurement.measurement_type = measurement_type
      measurement.activity = activity
      measurement.value = value
      measurement.save
    end

  	def happiness_score_for_category_at_time(category, time)
  		happiness_questions = []
  		if category.nil?
  			happiness_questions = HappinessQuestion.all
  		else
  			happiness_questions = category.happiness_questions
  		end

  		total_score = 0.0
  		total_num_questions_answered = 0
  		happiness_questions.each { |q|
  			new_score = q.most_recent_score_before(self, time)
  			unless new_score.nil?
  				total_score += new_score
  				total_num_questions_answered += 1
  			end
  		}

  		if total_num_questions_answered == 0
  			return 0.0
  		end

  		return total_score * 1.0 / total_num_questions_answered
  	end

	private
		def create_remember_token
			self.remember_token = User.digest(User.new_remember_token)
		end
end
