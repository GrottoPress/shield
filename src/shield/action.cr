module Shield::Action
  macro included
    include Shield::AuthorizationHelpers
    include Shield::AuthenticationHelpers

    include Shield::AuthenticationPipes
    include Shield::AuthorizationPipes

    before :remember_login
    before :require_logged_in
    before :require_authorization
    before :disable_caching

    private def remote_ip : Socket::IPAddress?
      Socket::IPAddress.parse(request.remote_address.to_s)
    rescue
      nil
    end
  end
end
