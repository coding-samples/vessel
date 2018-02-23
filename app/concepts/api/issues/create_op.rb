class Api::Issues::CreateOp
  class << self
    def execute(user, params)
      ::Issue.create!(issue_params(params)) do |issue|
        issue.author = user
      end
    end

    def allowed?(current_user, *)
      current_user.regular?
    end

    private

    def issue_params(params)
      params.slice(:title)
    end
  end
end