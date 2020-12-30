module Shield::PasswordResetHelpers
  macro included
    def redirect(to path : PasswordResetUrl, status : Int32 = 302)
      redirect(path.to_s, status)
    end
  end
end
