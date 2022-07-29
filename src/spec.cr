require "lucille/spec"
require "./shield"
require "./compat/spec"

abstract class Lucky::BaseHTTPClient
  include Shield::HttpClient
end
