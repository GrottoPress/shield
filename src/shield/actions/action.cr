module Shield::Action
  macro included
    include Lucky::Paginator::BackendHelpers

    include Shield::ActionHelpers
    include Shield::AuthenticationHelpers
    include Shield::AuthorizationHelpers

    include Shield::ActionPipes
    include Shield::AuthenticationPipes
    include Shield::AuthorizationPipes

    before :set_previous_page_url
    before :disable_caching
    before :require_logged_in
    before :require_logged_out
    before :pin_login_to_ip_address
    before :check_authorization
  end
end
