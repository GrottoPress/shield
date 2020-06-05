class CreatePasswordResets::V20200526145231 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(PasswordReset) do
      primary_key id : Int64

      add_timestamps
      add_belongs_to user : User, on_delete: :cascade

      add token_hash : String?
      add ip_address : String?
    end
  end

  def rollback
    drop table_for(PasswordReset)
  end
end
