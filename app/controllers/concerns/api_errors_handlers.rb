module ApiErrorsHandlers
  extend ActiveSupport::Concern

  included do
    # More general errors go first
    rescue_from StandardError,                with: :rescue_with_500
    rescue_from Auth::AuthorizationError,     with: :rescue_with_401
    rescue_from Auth::AuthenticationError,    with: :rescue_with_401
    rescue_from Auth::ForbiddenError,         with: :rescue_with_403
    rescue_from ActiveRecord::RecordNotFound, with: :rescue_with_404
    rescue_from ActiveRecord::RecordInvalid,  with: :rescue_with_422
  end

  def rescue_with_500(exception)
    default_error_handler(exception, 500)
  end

  def rescue_with_401(exception)
    default_error_handler(exception, 401)
  end

  def rescue_with_403(exception)
    default_error_handler(exception, 403)
  end

  def rescue_with_404(exception)
    default_error_handler(exception, 404)
  end

  def rescue_with_422(exception)
    default_error_handler(exception, 422)
  end

  def default_error_handler(exception, status)
    backtrace_cleaner = request.get_header "action_dispatch.backtrace_cleaner"
    wrapper = ActionDispatch::ExceptionWrapper.new(backtrace_cleaner, exception)
    log_exception(wrapper)
    render_exception(wrapper, status)
  end

  def render_exception(wrapper, status)
    exception = wrapper.exception
    error_text = exception.message
    status_text = Rack::Utils::HTTP_STATUS_CODES.fetch(status, error_text)
    json = {
        error: error_text,
        status: status,
        status_text: status_text,
    }
    if Rails.env.development?
      json[:backtrace] = backtrace(wrapper)
    end
    render json: json, status: status
  end

  def log_exception(wrapper)
    exception = wrapper.exception

    ActiveSupport::Deprecation.silence do
      message = "\n#{exception.class} (#{exception.message}):\n"
      message << exception.annoted_source_code.to_s if exception.respond_to?(:annoted_source_code)
      message << "  " << backtrace(wrapper).join("\n  ")
      Rails.logger.fatal("#{message}\n\n")
    end
  end

  def backtrace(wrapper)
    trace = wrapper.application_trace
    if trace.empty?
      trace = wrapper.framework_trace
    end
    trace
  end
end