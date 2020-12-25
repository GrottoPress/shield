class CurrentUser::Edit < BrowserAction
  include Shield::CurrentUser::Edit

  skip :pin_login_to_ip_address

  get "/profile/edit" do
    operation = UpdateCurrentUser.new(user)
    html EditPage, operation: operation
  end
end
