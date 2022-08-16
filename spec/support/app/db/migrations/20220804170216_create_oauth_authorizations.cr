class CreateOauthAuthorizations::V20220804170216 < Avram::Migrator::Migration::V1
  def migrate
    create :oauth_authorizations do
      primary_key id : Int64

      add_belongs_to oauth_client : OauthClient,
        on_delete: :cascade,
        foreign_key_type: UUID

      add_belongs_to user : User, on_delete: :cascade

      add active_at : Time
      add code_digest : String
      add inactive_at : Time?
      add pkce : JSON::Any?
      add scopes : Array(String)
      add success : Bool
    end
  end

  def rollback
    drop :oauth_authorizations
  end
end
