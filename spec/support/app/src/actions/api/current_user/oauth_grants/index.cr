class Api::CurrentUser::OauthGrants::Index < ApiAction
  include Shield::Api::CurrentUser::OauthGrants::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/account/oauth/grants" do
    json OauthGrantSerializer.new(oauth_grants: oauth_grants, pages: pages)
  end
end
