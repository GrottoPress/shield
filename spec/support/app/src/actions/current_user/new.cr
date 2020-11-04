class CurrentUser::New < BrowserAction
  include Shield::CurrentUser::New

  get "/register" do
    plain_text "CurrentUser::New"
  end
end
