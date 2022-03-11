struct ItemResponse < ApiResponse
  def initialize(
    @bearer_login : BearerLogin? = nil,
    @email_confirmation : EmailConfirmation? = nil,
    @login : Login? = nil,
    @message : String? = nil,
    @password_reset : PasswordReset? = nil,
    @token : String? = nil,
    @user : User? = nil,
  )
  end

  private def status : Status
    Status::Success
  end

  private def data_json : NamedTuple
    data = super
    data = add_bearer_login(data)
    data = add_email_confirmation(data)
    data = add_login(data)
    data = add_password_reset(data)
    data = add_token(data)
    data = add_user(data)
    data
  end

  private def add_bearer_login(data)
    @bearer_login.try do |bearer_login|
      data = data.merge({bearer_login: BearerLoginSerializer.new(bearer_login)})
    end

    data
  end

  private def add_email_confirmation(data)
    @email_confirmation.try do |email_confirmation|
      data = data.merge({
        email_confirmation: EmailConfirmationSerializer.new(email_confirmation)
      })
    end

    data
  end

  private def add_login(data)
    @login.try do |login|
      data = data.merge({login: LoginSerializer.new(login)})
    end

    data
  end

  private def add_password_reset(data)
    @password_reset.try do |password_reset|
      data = data.merge({
        password_reset: PasswordResetSerializer.new(password_reset)
      })
    end

    data
  end

  private def add_token(data)
    @token.try { |token| data = data.merge({token: token}) }
    data
  end

  private def add_user(data)
    @user.try { |user| data = data.merge({user: UserSerializer.new(user)}) }
    data
  end
end
