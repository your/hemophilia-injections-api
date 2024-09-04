class ApplicationController < ActionController::API
  rescue_from Exception, with: :handle_exception

  private

  def handle_exception(exception)
    Rails.logger.error(exception.message)
    Rails.logger.error(exception.backtrace.join("\n"))

    render json: {
      errors: [
        {
          title: "Internal Server Error",
          detail: exception.message,
          code: "500"
        }
      ]
    }, status: :internal_server_error
  end
end
