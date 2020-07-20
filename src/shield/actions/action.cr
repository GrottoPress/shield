module Shield::Action
  macro included
    include Shield::ActionHelpers
    include Shield::AuthenticationHelpers
    include Shield::AuthorizationHelpers

    include Shield::ActionPipes
    include Shield::AuthenticationPipes
    include Shield::AuthorizationPipes

    before :disable_caching
    before :require_logged_in

    after :require_authorization
    after :set_previous_page
  end
end
