class Errors::Show < Lucky::ErrorAction
  DEFAULT_MESSAGE = "Something went wrong."

  default_format :json

  dont_report [Lucky::RouteNotFoundError]

  def render(error : Lucky::RouteNotFoundError)
    error_json "Not found", status: 404
  end

  def render(error : Avram::InvalidOperationError)
    error_json message: error.renderable_message,
      details: error.renderable_details,
      param: error.invalid_attribute_name,
      status: 400
  end

  # Always keep this below other 'render' methods or it may override your
  # custom 'render' methods.
  def render(error : Lucky::RenderableError)
    error_json error.renderable_message, status: error.renderable_status
  end

  def default_render(error : Exception) : Lucky::Response
    error_json DEFAULT_MESSAGE, status: 500
  end

  private def error_json(
    message : String,
    status : Int,
    details = nil,
    param = nil
  )
    json(
      ErrorSerializer.new(
        error_message: message,
        details: details,
        param: param
      ),
      status: status
    )
  end

  def report(error : Exception) : Nil
    puts
    puts "===== ERROR ====="
    puts "#{error.inspect_with_backtrace}"
    puts "===== ERROR ====="
    puts
  end
end
