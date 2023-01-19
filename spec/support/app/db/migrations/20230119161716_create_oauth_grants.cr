class CreateOauthGrants::V20230119161716 < Avram::Migrator::Migration::V1
  def migrate
    create :oauth_grants do
      primary_key id : Int64

      add_timestamps

      add_belongs_to oauth_client : OauthClient,
        foreign_key_type: UUID,
        on_delete: :cascade

      add_belongs_to user : User, on_delete: :cascade

      add active_at : Time
      add code_digest : String
      add inactive_at : Time?
      add metadata : JSON::Any?
      add scopes : Array(String)
      add success : Bool
      add type : String
    end
  end

  def rollback
    drop :oauth_grants
  end
end
