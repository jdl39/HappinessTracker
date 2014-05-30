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
      return measurement
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

    def self.from_omniauth(auth)
        where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
          user.provider = auth.provider
          user.uid = auth.uid
          name = auth.info.name
          user.username = name + user.uid
          user.first_name = name.split[0]
          user.last_name = name.split[1].nil? ? "" : name.split[1]
          user.oauth_token = auth.credentials.token
          user.oauth_expires_at = Time.at(auth.credentials.expires_at)
          user.password = SecureRandom.urlsafe_base64
          user.password_confirmation = user.password
          user.email = ""
          user.save!
        end
    end

    def activity_recommendations
        score_hash = {}
        for activity_type in ActivityType.all do
            prior = activity_type.activities.size
            prior *= 1.0 / User.all.size
            score_hash[activity_type.name] = prior
        end

        for activity in self.activities do
            count_hash = Hash.new { |hash,key| hash[key] = 1 }
            this_activity_type = activity.activity_type
            for other_instance in this_activity_type.activities do
                for activity_to_count in other_instance.user.activities do
                    count_hash[activity_to_count.activity_type.name] += 1
                end
            end

            for activity_type in ActivityType.all do
                score_hash[activity_type.name] *= count_hash[activity_type.name] * 1.0 / this_activity_type.activities.size
            end
        end

        existing_activities = self.activities.map{|activity| activity.activity_type.name}
        recommendations = []
        score_hash.sort_by { |activity_name, score| 1.0 - score }.each { |tuple| 
            recommendations << tuple[0] unless existing_activities.include? tuple[0]
        }
        return recommendations
    end

	private
		def create_remember_token
			self.remember_token = User.digest(User.new_remember_token)
		end
end
