class CurrentLogin::New < BrowserAction
  include Shield::CurrentLogin::New

  get "/log-in" do
    plain_text "CurrentLogin::New"
  end
end
