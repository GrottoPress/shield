module Shield::ApiAction
  macro included
    include Lucky::Paginator::BackendHelpers

    include Shield::ActionHelpers
    include Shield::ActionPipes
  end
end
