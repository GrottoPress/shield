class CreatePasswordResets::V20230119160731 < Avram::Migrator::Migration::V1
  def migrate
    create :password_resets do
      primary_key id : Int64

      add_timestamps

      add_belongs_to user : User, on_delete: :cascade

      add active_at : Time
      add inactive_at : Time?
      add ip_address : String
      add success : Bool
      add token_digest : String
    end
  end

  def rollback
    drop :password_resets
  end
end
