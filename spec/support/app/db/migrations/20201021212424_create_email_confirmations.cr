class CreateEmailConfirmations::V20201021212424 < Avram::Migrator::Migration::V1
  def migrate
    create :email_confirmations do
      primary_key id : Int64

      add_belongs_to user : User?, on_delete: :cascade

      add email : String

      add token_digest : String
      add ip_address : String
      add status : String
      add started_at : Time
      add ended_at : Time?
    end
  end

  def rollback
    drop :email_confirmations
  end
end
