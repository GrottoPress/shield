class AddOauthAccessTokenNotifyToUserOptions::V20220825174620 < Avram::Migrator::Migration::V1
  def migrate
    alter :user_options do
      add oauth_access_token_notify : Bool, fill_existing_with: true
    end
  end

  def rollback
    alter :user_options do
      remove :oauth_access_token_notify
    end
  end
end
