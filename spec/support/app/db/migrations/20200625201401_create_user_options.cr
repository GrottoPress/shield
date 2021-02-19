class CreateUserOptions::V20200625201401 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(UserOptions) do
      primary_key id : Int64

      add_timestamps
      add_belongs_to user : User, on_delete: :cascade, unique: true

      add login_notify : Bool
      add password_notify : Bool
    end
  end

  def rollback
    drop table_for(UserOptions)
  end
end
