module Shield::StartAuthentication
  macro included
    include Shield::BeginDuration
    include Shield::SetToken
  end
end
