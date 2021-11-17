module Shield::ApiAction
  macro included
    include Lucky::Paginator::BackendHelpers
    include Lucille::ActionHelpers
    include Shield::ActionPipes
  end
end
