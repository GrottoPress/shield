class Logins::Destroy < ApiAction
  include Shield::DestroyLogin

  delete "/log-out" do
    log_user_out
  end
end
