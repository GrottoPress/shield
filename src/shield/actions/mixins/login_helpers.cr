module Shield::LoginHelpers
  macro included
    def logged_in? : Bool
      !logged_out?
    end

    def logged_out? : Bool
      current_user?.nil?
    end

    def current_user
      current_user?.not_nil!
    end

    getter? current_user : User? do
      current_login?.try &.user
    end

    def current_login
      current_login?.not_nil!
    end

    getter? current_login : Login? do
      LoginSession.new(context).verify
    end
  end
end
