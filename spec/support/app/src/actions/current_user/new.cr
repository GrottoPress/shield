class CurrentUser::New < BrowserAction
  include Shield::CurrentUser::New

  get "/register" do
    operation = RegisterCurrentUser.new
    html NewPage, operation: operation
  end
end
