class OauthClient < BaseModel
  include Shield::OauthClient
  include Shield::HasManyOauthGrants

  skip_default_columns
  primary_key id : UUID

  table :oauth_clients {}
end
