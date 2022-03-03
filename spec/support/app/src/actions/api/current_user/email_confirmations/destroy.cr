class Api::CurrentUser::EmailConfirmations::Destroy < ApiAction
  include Shield::Api::CurrentUser::EmailConfirmations::Destroy

  delete "/account/email-confirmations" do
    run_operation
  end

  def remote_ip? : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
