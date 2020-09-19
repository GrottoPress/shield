class ChangeTypeOfLevelToStringInUser::V20200730153320 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(User) do
      change_type level : String
    end
  end

  def rollback
    alter table_for(User) do
      change_type level : Int32
    end
  end
end
