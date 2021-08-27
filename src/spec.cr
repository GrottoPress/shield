require "lucille/spec"
require "./shield"

abstract class Lucky::BaseHTTPClient
  include Shield::HttpClient
end
