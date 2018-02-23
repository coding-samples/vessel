class Api::Issues::ChangeStatusOp
  class << self
    def execute(id, status)
      issue = ::Issue.find(id)
      issue.update_attributes!(status: status)
      issue
    end

    def allowed?(current_user, id, *)
      current_user.manager? && ::Issue.find(id).manager == current_user
    end
  end
end