class AddOauthAuthorizationsType::V20220829152248 <
  Avram::Migrator::Migration::V1

  def migrate
    alter :oauth_authorizations do
      add type : String, fill_existing_with: "authorization_code"
    end
  end

  def rollback
    alter :oauth_authorizations do
      remove :type
    end
  end
end
