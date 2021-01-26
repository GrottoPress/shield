module Shield::StartAuthentication
  macro included
    include Shield::Activate
    include Shield::SetToken
  end
end
