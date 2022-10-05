class RenameOauthClientsRedirectUriToRedirectUris::V20221005174949 <
  Avram::Migrator::Migration::V1

  def migrate
    alter :oauth_clients do
      rename :redirect_uri, :redirect_uris
    end
  end

  def rollback
    alter :oauth_clients do
      rename :redirect_uris, :redirect_uri
    end
  end
end
