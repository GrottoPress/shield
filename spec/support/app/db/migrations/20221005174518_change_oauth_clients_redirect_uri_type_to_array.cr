class ChangeOauthClientsRedirectUriTypeToArray::V20221005174518 <
  Avram::Migrator::Migration::V1

  def migrate
    execute <<-SQL
      ALTER TABLE oauth_clients
      ALTER COLUMN redirect_uri TYPE text[] USING array[redirect_uri];
      SQL
  end

  def rollback
    execute <<-SQL
      ALTER TABLE oauth_clients
      ALTER COLUMN redirect_uri TYPE text USING coalesce(redirect_uri[1],'');
      SQL
  end
end
