class Api::RegularCurrentUser::Create < ApiAction
  include Shield::Api::CurrentUser::Create

  skip :pin_login_to_ip_address

  post "/register" do
    run_operation
  end

  def run_operation
    RegisterRegularCurrentUser.create(params) do |operation, user|
      if operation.saved?
        do_run_operation_succeeded(operation, user.not_nil!)
      else
        do_run_operation_failed(operation)
      end
    end
  end
end
