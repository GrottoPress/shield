class RenameOauthAuthorizationsPkceToMetadata::V20220829151859 <
  Avram::Migrator::Migration::V1

  def migrate
    alter :oauth_authorizations do
      rename :pkce, :metadata
    end
  end

  def rollback
    alter :oauth_authorizations do
      rename :metadata, :pkce
    end
  end
end
