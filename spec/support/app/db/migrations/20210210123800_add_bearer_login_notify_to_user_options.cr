class AddBearerLoginNotifyToUserOptions::V20210210123800 < Avram::Migrator::Migration::V1
  def migrate
    alter :user_options do
      add bearer_login_notify : Bool, fill_existing_with: false
    end
  end

  def rollback
    alter :user_options do
      remove :bearer_login_notify
    end
  end
end
