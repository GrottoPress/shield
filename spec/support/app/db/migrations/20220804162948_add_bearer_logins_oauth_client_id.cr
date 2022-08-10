class AddBearerLoginsOauthClientId::V20220804162948 <
  Avram::Migrator::Migration::V1

  def migrate
    alter :bearer_logins do
      add_belongs_to oauth_client : OauthClient?,
        on_delete: :cascade,
        foreign_key_type: UUID
    end
  end

  def rollback
    alter :bearer_logins do
      remove_belongs_to :oauth_client
    end
  end
end
