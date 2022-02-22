@[Deprecated("Use `StartCurrentLogin` instead")]
class LogUserIn < Login::SaveOperation
  include Shield::StartLogin
end

@[Deprecated("Use `EndCurrentLogin` instead")]
class LogUserOut < Login::SaveOperation
  include Shield::EndLogin
end

module Shield::DeleteLoginsOnPasswordChange
  macro included
    {% puts "Warning: Deprecated `Shield::DeleteLoginsOnPasswordChange`. \
      Use `Shield::DeleteUserLoginsOnPasswordChange` instead" %}

    include Shield::DeleteUserLoginsOnPasswordChange
  end
end
