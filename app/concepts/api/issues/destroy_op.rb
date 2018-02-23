class Api::Issues::DestroyOp
  class << self
    def execute(id)
      issue = ::Issue.find(id)
      issue.destroy!
      issue
    end

    def allowed?(current_user, id)
      current_user.regular? && ::Issue.find(id).author == current_user
    end
  end
end