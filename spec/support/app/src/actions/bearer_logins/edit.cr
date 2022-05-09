class BearerLogins::Edit < BrowserAction
  include Shield::BearerLogins::Edit

  skip :check_authorization
  skip :pin_login_to_ip_address

  get "/bearer_logins/:bearer_login_id/edit" do
    operation = UpdateBearerLogin.new(
      bearer_login,
      allowed_scopes: BearerScope.action_scopes.map(&.name)
    )

    html EditPage, operation: operation
  end
end
