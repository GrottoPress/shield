module Shield::ApiAction
  macro included
    include Lucky::Paginator::BackendHelpers

    include Shield::ActionHelpers
    include Shield::Api::AuthenticationHelpers
    include Shield::Api::AuthorizationHelpers

    include Shield::ActionPipes
    include Shield::Api::AuthenticationPipes
    include Shield::Api::AuthorizationPipes

    before :disable_caching
    before :require_logged_in
    before :require_logged_out
    before :pin_login_to_ip_address
    before :check_authorization

    after :set_previous_page_url
  end
end
