class Api::IssuesController < Api::ApplicationController
  
  def index
    execute_operation(Api::Issues::SearchOp, current_user, params) do |issues|
      respond_with(issues, serializer: Api::Issues::IssuesJson)
    end
  end

  def create
    execute_operation(Api::Issues::CreateOp, current_user, issue_params) do |issue|
      respond_with(issue, serializer: Api::Issues::IssueJson, status: 201)
    end
  end

  def update
    execute_operation(Api::Issues::UpdateOp, current_user, params[:id], issue_params) do |issue|
      respond_with(issue, serializer: Api::Issues::IssueJson)
    end
  end

  def delete
    execute_operation(Api::Issues::DestroyOp, current_user, params[:id]) do
      head :destroyed
    end
  end

  def check_in
    execute_operation(Api::Issues::CheckInOp, params[:id], current_user) do |issue|
      respond_with(issue, serializer: Api::Issues::IssueJson)
    end
  end

  def check_out
    execute_operation(Api::Issues::CheckOutOp, params[:id]) do |issue|
      respond_with(issue, serializer: Api::Issues::IssueJson)
    end
  end

  def update_status
    execute_operation(Api::Issues::ChangeStatusOp, params[:id], issue_params[:status]) do |issue|
      respond_with(issue, serializer: Api::Issues::IssueJson)
    end
  end

  private

  def issue_params
    params.require(:issue).permit!
  end
end
