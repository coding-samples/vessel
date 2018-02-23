class Api::Issues::CheckInOp
  class << self
    def execute(id, user)
      issue = ::Issue.find(id)
      issue.update_attributes!(manager: user)
      issue
    end

    def allowed?(current_user, id, *)
      return false if current_user.regular?
      issue = ::Issue.find(id)
      return true unless issue.assigned?
      issue.manager_id == current_user.id
    end
  end
end