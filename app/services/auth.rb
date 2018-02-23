class Auth

  AuthenticationError = Class.new(StandardError)
  AuthorizationError = Class.new(StandardError)
  ForbiddenError = Class.new(StandardError)

  class << self
    def authorize(auth_token)
      raise Auth::AuthorizationError.new if auth_token.blank?

      decoded_session = JwtSession.decode(auth_token)
      raise Auth::AuthorizationError.new if decoded_session.blank?

      User.find(decoded_session[:current_user_id])
    rescue => e
      raise AuthorizationError.new(e)
    end

    def authenticate(login, password)
      user = User.find_by_login(login)
      raise Auth::AuthenticationError.new if user.blank? || !user.authenticate(password)
      JwtSession.encode(current_user_id: user.id)
    end
  end
end