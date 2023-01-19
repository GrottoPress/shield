class CreateUserOptions::V20230119175313 < Avram::Migrator::Migration::V1
  def migrate
    create :user_options do
      primary_key id : Int64

      add_timestamps
      add_belongs_to user : User, unique: true, on_delete: :cascade

      add bearer_login_notify : Bool, default: false
      add login_notify : Bool
      add oauth_access_token_notify : Bool, default: true
      add password_notify : Bool
    end
  end

  def rollback
    drop :user_options
  end
end
