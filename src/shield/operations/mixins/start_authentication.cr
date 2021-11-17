module Shield::StartAuthentication
  macro included
    include Lucille::Activate
    include Shield::SetToken
  end
end
