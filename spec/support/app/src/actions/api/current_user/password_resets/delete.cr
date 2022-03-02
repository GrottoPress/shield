class Api::CurrentUser::PasswordResets::Delete < ApiAction
  include Shield::Api::CurrentUser::PasswordResets::Delete

  delete "/account/password-resets/delete" do
    run_operation
  end

  def remote_ip? : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
