class CurrentUser::Edit < BrowserAction
  include Shield::EmailConfirmationCurrentUser::Edit

  skip :pin_login_to_ip_address

  get "/ec/profile/edit" do
    operation = UpdateCurrentUser.new(
      user,
      remote_ip: remote_ip?,
      current_login: current_login?
    )

    html EditPage, operation: operation
  end
end
