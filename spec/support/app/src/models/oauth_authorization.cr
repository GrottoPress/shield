class OauthAuthorization < BaseModel
  include Shield::OauthAuthorization

  skip_default_columns
  primary_key id : Int64

  table :oauth_authorizations {}
end
