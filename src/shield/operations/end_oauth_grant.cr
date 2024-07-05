module Shield::EndOauthGrant # OauthGrant::SaveOperation
  macro included
    include Lucille::Deactivate
  end
end
