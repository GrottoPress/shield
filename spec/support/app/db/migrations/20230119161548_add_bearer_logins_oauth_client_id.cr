class AddBearerLoginsOauthClientId::V20230119161548 <
  Avram::Migrator::Migration::V1

  def migrate
    alter :bearer_logins do
      add_belongs_to oauth_client : OauthClient?,
        foreign_key_type: UUID,
        on_delete: :cascade
    end
  end

  def rollback
    alter :bearer_logins do
      remove_belongs_to :oauth_client
    end
  end
end
