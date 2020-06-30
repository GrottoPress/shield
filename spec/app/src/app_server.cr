class AppServer < Lucky::BaseAppServer
  def middleware : Array(HTTP::Handler)
    [
      # Lucky::ForceSSLHandler.new,
      Lucky::HttpMethodOverrideHandler.new,
      # Lucky::LogHandler.new,
      # Lucky::ErrorHandler.new(action: Errors::Show),
      # Lucky::RemoteIpHandler.new,
      Lucky::RouteHandler.new,
      # Lucky::StaticCompressionHandler.new(
      #   "./public",
      #   file_ext: "gz",
      #   content_encoding: "gzip"
      # ),
      # Lucky::StaticFileHandler.new("./public", false),
      Lucky::RouteNotFoundHandler.new,
    ] of HTTP::Handler
  end
end
