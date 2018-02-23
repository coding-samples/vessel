class Api::Users::SignUpOp
  class << self
    def execute(params)
      User.create!(params[:login]) do |user|
        user.attributes = user_params(params)
      end
    end

    def allowed?(*)
      true
    end

    private

    def user_params(params)
      (params[:user].presence || params).slice(:login, :password, :name, :role)
    end
  end
end