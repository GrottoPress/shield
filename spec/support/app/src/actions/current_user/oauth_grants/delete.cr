class CurrentUser::OauthGrants::Delete < BrowserAction
  include Shield::CurrentUser::OauthGrants::Delete

  skip :pin_login_to_ip_address

  delete "/account/oauth/grants/delete" do
    run_operation
  end

  def do_run_operation_succeeded(operation, user)
    response.headers["X-User-ID"] = user.id.to_s
    previous_def
  end
end
