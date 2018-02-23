class Api::UsersController < Api::ApplicationController

  skip_before_action :authorize_user

  def sign_in
    execute_operation(Api::Users::SignInOp, params[:login], params[:password]) do |token|
      respond_with(token)
    end
  end

  def sign_up
    execute_operation(Api::Users::SignUpOp, params) do |user|
      respond_with(user, serializer: Api::Users::UserJson)
    end
  end
end