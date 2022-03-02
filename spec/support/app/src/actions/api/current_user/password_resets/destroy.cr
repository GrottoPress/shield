class Api::CurrentUser::PasswordResets::Destroy < ApiAction
  include Shield::Api::CurrentUser::PasswordResets::Destroy

  delete "/account/password-resets" do
    run_operation
  end

  def remote_ip? : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
