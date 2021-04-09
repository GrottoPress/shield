class CreatePasswordResets::V20200526145231 < Avram::Migrator::Migration::V1
  def migrate
    create :password_resets do
      primary_key id : Int64

      add_timestamps
      add_belongs_to user : User, on_delete: :cascade

      add token_hash : String?
      add ip_address : String?
    end
  end

  def rollback
    drop :password_resets
  end
end
