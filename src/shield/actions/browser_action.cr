module Shield::BrowserAction
  macro included
    include Lucky::ProtectFromForgery
    include Lucky::Paginator::BackendHelpers

    include Lucille::ActionHelpers

    include Shield::ActionHelpers
    include Shield::ActionPipes
  end
end
