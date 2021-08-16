class AddSettingsToUsers::V20210815163059 < Avram::Migrator::Migration::V1
  def migrate
    alter :users do
      add settings : JSON::Any, default: JSON.parse({
        password_notify: true,
        bearer_login_notify: true,
        login_notify: true
      }.to_json)
    end
  end

  def rollback
    alter :users do
      remove :settings
    end
  end
end
