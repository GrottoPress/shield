class Api::CurrentUser::EmailConfirmations::Delete < ApiAction
  include Shield::Api::CurrentUser::EmailConfirmations::Delete

  delete "/account/email-confirmations/delete" do
    run_operation
  end

  def remote_ip? : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
