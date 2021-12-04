module Shield::Api::EmailConfirmationCurrentUser::Update
  macro included
    include Shield::Api::CurrentUser::Update

    # patch "/account" do
    #   run_operation
    # end

    def run_operation
      UpdateCurrentUser.update(
        user,
        params,
        current_login: current_login?,
        remote_ip: remote_ip?
      ) do |operation, updated_user|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_user)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, user)
      if LuckyEnv.production? || operation.new_email.nil?
        json({
          status: "success",
          message: success_message(operation),
          data: {user: UserSerializer.new(user)}
        })
      else
        json({
          status: "success",
          message: success_message(operation),
          data: {
            user: UserSerializer.new(user),
            token: BearerToken.new(
              operation.start_email_confirmation.not_nil!,
              operation.email_confirmation.not_nil!
            )
          }
        })
      end
    end

    private def success_message(operation)
      email = operation.new_email
      return Rex.t(:"action.current_user.update.success") unless email

      LuckyEnv.production? ?
        Rex.t(:"action.current_user.update.success_confirm", email: email) :
        Rex.t(:"action.misc.dev_mode_skip_email", email: email)
    end
  end
end
