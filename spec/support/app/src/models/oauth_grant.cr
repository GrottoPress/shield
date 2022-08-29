class OauthGrant < BaseModel
  include Shield::OauthGrant

  skip_default_columns
  primary_key id : Int64

  table :oauth_authorizations {}
end
