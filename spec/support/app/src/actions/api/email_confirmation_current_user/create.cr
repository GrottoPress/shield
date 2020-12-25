class Api::EmailConfirmationCurrentUser::Create < ApiAction
  include Shield::Api::EmailConfirmationCurrentUser::Create

  post "/ec" do
    run_operation
  end

  private def register_user(email_confirmation)
    RegisterEmailConfirmationCurrentUser.create(
      params,
      email_confirmation: email_confirmation
    ) do |operation, user|
      if user
        do_run_operation_succeeded(operation, user.not_nil!)
      else
        do_run_operation_failed(operation)
      end
    end
  end

  def remote_ip : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
