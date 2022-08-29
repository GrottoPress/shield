class Api::OauthGrants::Index < ApiAction
  include Shield::Api::OauthGrants::Index

  skip :check_authorization
  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/oauth/grants" do
    json OauthGrantSerializer.new(oauth_grants: oauth_grants, pages: pages)
  end
end
