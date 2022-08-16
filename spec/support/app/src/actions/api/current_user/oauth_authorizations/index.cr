class Api::CurrentUser::OauthAuthorizations::Index < ApiAction
  include Shield::Api::CurrentUser::OauthAuthorizations::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/account/oauth/authorizations" do
    json OauthAuthorizationSerializer.new(
      oauth_authorizations: oauth_authorizations,
      pages: pages
    )
  end
end
