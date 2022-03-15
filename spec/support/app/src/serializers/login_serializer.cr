struct LoginSerializer < SuccessSerializer
  def initialize(
    @login : Login? = nil,
    @logins : Array(Login)? = nil,
    @message : String? = nil,
    @pages : Lucky::Paginator? = nil,
    @token : String? = nil,
    @user : User? = nil,
  )
  end

  def self.item(login : Login)
    {type: login.class.name}
  end

  private def data_json : NamedTuple
    data = super
    data = add_login(data)
    data = add_logins(data)
    data = add_token(data)
    data = add_user(data)
    data
  end

  private def add_login(data)
    @login.try { |login| data = data.merge({login: self.class.item(login)}) }
    data
  end

  private def add_logins(data)
    @logins.try do |logins|
      data = data.merge({logins: self.class.list(logins)})
    end

    data
  end

  private def add_token(data)
    @token.try { |token| data = data.merge({token: token }) }
    data
  end

  private def add_user(data)
    @user.try { |user| data = data.merge({user: UserSerializer.item(user)}) }
    data
  end
end
