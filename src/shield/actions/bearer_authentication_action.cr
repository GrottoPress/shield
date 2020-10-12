module Shield::BearerAuthenticationAction
  macro included
    include Shield::BearerAuthenticationHelpers
    include Shield::BearerAuthenticationPipes
  end
end
