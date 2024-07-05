module Shield::RegisterOauthClient # OauthClient::SaveOperation
  macro included
    permit_columns :name, :redirect_uris

    attribute public : Bool

    include Lucille::Activate
    include Lucille::SetUserIdFromUser
    include Shield::SetSecret
    include Shield::ValidateOauthClient

    private def set_secret
      return if public.value
      previous_def
    end
  end
end
