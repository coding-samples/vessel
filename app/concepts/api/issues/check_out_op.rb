class Api::Issues::CheckOutOp
  class << self
    def execute(id)
      issue = ::Issue.find(id)
      issue.update_attributes!(manager: nil)
      issue
    end

    def allowed?(current_user, id)
      return false if current_user.regular?
      issue = ::Issue.find(id)
      return true unless issue.assigned?
      issue.manager == current_user
    end
  end
end