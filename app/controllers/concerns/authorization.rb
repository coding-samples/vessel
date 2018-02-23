module Authorization
  extend ActiveSupport::Concern

  included do
    before_action :authorize_user

    attr_reader :current_user
  end

  private

  def authorize_user
    auth_token = request.headers['HTTP_AUTHORIZATION'].to_s.split(' ').last
    @current_user = Auth.authorize(auth_token)
  end

end