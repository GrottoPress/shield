module Shield::NewPasswordReset
  macro included
    skip :require_logged_in
    before :require_logged_out
  end
end
