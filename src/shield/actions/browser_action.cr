module Shield::BrowserAction
  macro included
    include Lucky::ProtectFromForgery
    include Lucky::Paginator::BackendHelpers

    include Shield::ActionHelpers
    include Shield::ActionPipes
  end
end
