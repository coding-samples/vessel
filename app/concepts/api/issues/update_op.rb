class Api::Issues::UpdateOp
  class << self
    def execute(id, params)
      issue = ::Issue.find(id)
      issue.update_attributes!(issue_params(params))
      issue
    end

    def allowed?(current_user, id, *)
      current_user.regular? && ::Issue.find(id).author == current_user
    end

    private

    def issue_params(params)
      params.slice(:title)
    end
  end
end