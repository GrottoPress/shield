class MakeEmailColumnsCaseInsensitive::V20210208203704 < Avram::Migrator::Migration::V1
  def migrate
    enable_extension "citext"

    alter table_for(User) do
      change_type email : String, case_sensitive: false
    end

    alter table_for(EmailConfirmation) do
      change_type email : String, case_sensitive: false
    end
  end

  def rollback
    alter table_for(User) do
      change_type email : String, case_sensitive: true
    end

    alter table_for(EmailConfirmation) do
      change_type email : String, case_sensitive: true
    end
  end
end
