class Api::Issues::SearchOp
  class << self
    def execute(user, params = {})
      scope = ::Issue.order(id: :desc)
      scope = scope.where(author: user) if user.regular?
      scope = filter_by_status(scope, params)
      scope = paginate(scope, params.slice(:page, :per_page))
      scope
    end

    def allowed?(*)
      true
    end

    private

    def filter_by_status(scope, params)
      return scope if params[:status].blank?
      scope.where(status: params[:status])
    end

    def paginate(scope, page: 1, per_page: 25)
      scope.page(page).per([100, per_page.to_i].min)
    end
  end
end