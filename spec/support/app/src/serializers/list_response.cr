struct ListResponse < ApiResponse
  def initialize(
    @pages : Lucky::Paginator,
    @bearer_logins : Array(BearerLogin)? = nil,
    @email_confirmations : Array(EmailConfirmation)? = nil,
    @logins : Array(Login)? = nil,
    @message : String? = nil,
    @password_resets : Array(PasswordReset)? = nil,
    @token : String? = nil,
    @user : User? = nil,
    @users : Array(User)? = nil,
  )
  end

  def render
    super.merge({pages: PaginationSerializer.new(@pages)})
  end

  private def status : Status
    Status::Success
  end

  private def data_json : NamedTuple
    data = super
    data = add_bearer_logins(data)
    data = add_email_confirmations(data)
    data = add_logins(data)
    data = add_password_resets(data)
    data = add_token(data)
    data = add_user(data)
    data = add_users(data)
    data
  end

  private def add_bearer_logins(data)
    @bearer_logins.try do |bearer_logins|
      data = data.merge({
        bearer_logins: BearerLoginSerializer.list(bearer_logins)
      })
    end

    data
  end

  private def add_email_confirmations(data)
    @email_confirmations.try do |email_confirmations|
      data = data.merge({
        email_confirmations: EmailConfirmationSerializer.list(
          email_confirmations
        )
      })
    end

    data
  end

  private def add_logins(data)
    @logins.try do |logins|
      data = data.merge({logins: LoginSerializer.list(logins)})
    end

    data
  end

  private def add_password_resets(data)
    @password_resets.try do |password_resets|
      data = data.merge({
        password_resets: PasswordResetSerializer.list(password_resets)
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

  private def add_users(data)
    @users.try do |users|
      data = data.merge({users: UserSerializer.list(users)})
    end

    data
  end
end
