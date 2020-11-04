class CurrentLogin::Destroy < BrowserAction
  include Shield::CurrentLogin::Destroy

  delete "/log-out" do
    run_operation
  end
end
