class ApiClient < Lucky::BaseHTTPClient
  include Shield::HttpClient

  def initialize
    super
    headers("Content-Type": "application/json")
  end
end
