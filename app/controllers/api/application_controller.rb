class Api::ApplicationController < ActionController::API
  include ActionController::Caching
  include ApiErrorsHandlers
  include Authorization

  def execute_operation(op, *args)
    if op.allowed?(current_user, *args)
      result = op.execute(*args)
      if block_given?
        yield(result)
      else
        result
      end
    else
      raise Auth::ForbiddenError.new
    end
  end

  def respond_with(model, serializer: nil, status: 200)
    if model.respond_to?(:errors) && model.errors.any?
      render status: 422, json: model.errors
    else
      render json: serializer ? serializer.to_json(model) : model, status: status
    end
  end
end
