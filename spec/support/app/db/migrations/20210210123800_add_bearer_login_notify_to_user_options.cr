class AddBearerLoginNotifyToUserOptions::V20210210123800 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(UserOptions) do
      add bearer_login_notify : Bool, fill_existing_with: false
    end
  end

  def rollback
    alter table_for(UserOptions) do
      remove :bearer_login_notify
    end
  end
end
