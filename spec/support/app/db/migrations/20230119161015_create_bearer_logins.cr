class CreateBearerLogins::V20230119161015 < Avram::Migrator::Migration::V1
  def migrate
    create :bearer_logins do
      primary_key id : Int64

      add_timestamps

      add_belongs_to user : User, on_delete: :cascade

      add active_at : Time
      add inactive_at : Time?
      add name : String
      add scopes : Array(String)
      add token_digest : String
    end
  end

  def rollback
    drop :bearer_logins
  end
end
