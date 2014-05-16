module SessionsHelper
	def sign_in(user)
		remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.digest(remember_token))
    self.current_user = user
	end

	def sign_out
    if not signed_in?
      return
    end
    current_user.update_attribute(:remember_token,
                                  User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

	def signed_in?
    !current_user.nil?
  end

	def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def are_friends(user_id_1, user_id_2)
    (!Friend.where(user_id:user_id_1, friend_id:user_id_2, accepted:true).blank? ||
     !Friend.where(user_id:user_id_2, friend_id:user_id_1, accepted:true).blank?)
  end

  def friend_request_exists(user_id_1, user_id_2)
    (!Friend.where(user_id:user_id_1, friend_id:user_id_2).blank? ||
     !Friend.where(user_id:user_id_2, friend_id:user_id_1).blank?)
  end	

  def is_current_user(username)
    username == current_user.username
  end

end
