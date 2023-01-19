class CreateUsers::V20230119160301 < Avram::Migrator::Migration::V1
  def migrate
    create :users do
      primary_key id : Int64

      add_timestamps

      add email : String, unique: true
      add level : String
      add password_digest : String
    end
  end

  def rollback
    drop :users
  end
end
