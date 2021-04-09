class CreateUsers::V20200526145001 < Avram::Migrator::Migration::V1
  def migrate
    create :users do
      primary_key id : Int64

      add_timestamps

      add email : String, unique: true
      add level : Int32
      add password_hash : String
    end
  end

  def rollback
    drop :users
  end
end
