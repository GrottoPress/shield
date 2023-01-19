class AddUserSettings::V20230119175638 < Avram::Migrator::Migration::V1
  def migrate
    alter :users do
      add settings : JSON::Any, default: JSON.parse({
        bearer_login_notify: true,
        login_notify: true,
        oauth_access_token_notify: true,
        password_notify: true,
      }.to_json)
    end
  end

  def rollback
    alter :users do
      remove :settings
    end
  end
end
