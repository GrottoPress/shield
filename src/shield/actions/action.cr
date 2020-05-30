module Shield::Action
  macro included
    include Shield::AuthenticationHelpers
    include Shield::AuthorizationHelpers

    include Shield::AuthenticationPipes
    include Shield::AuthorizationPipes

    before :disable_caching
    before :remember_login
    before :require_logged_in

    after :require_authorization

    private def remote_ip : Socket::IPAddress?
      Socket::IPAddress.parse(request.remote_address.to_s)
    rescue
      nil
    end
  end
end
