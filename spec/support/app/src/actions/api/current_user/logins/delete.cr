class Api::CurrentUser::Logins::Delete < ApiAction
  include Shield::Api::CurrentUser::Logins::Delete

  delete "/account/logins/delete" do
    run_operation
  end

  def remote_ip? : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
