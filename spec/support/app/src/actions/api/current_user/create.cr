class Api::CurrentUser::Create < ApiAction
  include Shield::Api::EmailConfirmationCurrentUser::Create

  post "/ec" do
    run_operation
  end

  def remote_ip : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
