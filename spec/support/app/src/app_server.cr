class AppServer < Lucky::BaseAppServer
  def middleware : Array(HTTP::Handler)
    [
      Lucky::HttpMethodOverrideHandler.new,
      Lucky::ErrorHandler.new(action: Errors::Show),
      Lucky::RouteHandler.new,
      Lucky::RouteNotFoundHandler.new,
    ] of HTTP::Handler
  end
end
