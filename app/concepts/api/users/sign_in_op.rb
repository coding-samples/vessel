class Api::Users::SignInOp
  class << self
    def execute(login, password)
      Auth.authenticate(login, password)
    end

    def allowed?(*)
      true
    end
  end
end