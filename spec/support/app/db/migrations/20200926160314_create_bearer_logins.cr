class CreateBearerLogins::V20200926160314 < Avram::Migrator::Migration::V1
  def migrate
    create :bearer_logins do
      primary_key id : Int64

      add_belongs_to user : User, on_delete: :cascade

      add name : String
      add scopes : Array(String)

      add token_digest : String
      add status : String
      add started_at : Time
      add ended_at : Time?
    end
  end

  def rollback
    drop :bearer_logins
  end
end
