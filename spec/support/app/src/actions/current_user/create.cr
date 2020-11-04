class CurrentUser::Create < BrowserAction
  include Shield::CurrentUser::Create

  post "/register" do
    run_operation
  end
end
