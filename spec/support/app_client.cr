class AppClient < Lucky::BaseHTTPClient
  def initialize
    super
    headers("Content-Type": "application/json")
  end
end
