class CreateEmailConfirmations::V20230119160922 < Avram::Migrator::Migration::V1
  def migrate
    create :email_confirmations do
      primary_key id : Int64

      add_timestamps

      add_belongs_to user : User?, on_delete: :cascade

      add active_at : Time
      add email : String
      add inactive_at : Time?
      add ip_address : String
      add success : Bool
      add token_digest : String
    end
  end

  def rollback
    drop :email_confirmations
  end
end
