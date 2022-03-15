struct BearerLoginSerializer < SuccessSerializer
  def initialize(
    @bearer_login : BearerLogin? = nil,
    @bearer_logins : Array(BearerLogin)? = nil,
    @message : String? = nil,
    @pages : Lucky::Paginator? = nil,
    @token : String? = nil,
    @user : User? = nil,
  )
  end

  def self.item(bearer_login : BearerLogin)
    {type: bearer_login.class.name}
  end

  private def data_json : NamedTuple
    data = super
    data = add_bearer_login(data)
    data = add_bearer_logins(data)
    data = add_token(data)
    data = add_user(data)
    data
  end

  private def add_bearer_login(data)
    @bearer_login.try do |bearer_login|
      data = data.merge({bearer_login: self.class.item(bearer_login)})
    end

    data
  end

  private def add_bearer_logins(data)
    @bearer_logins.try do |bearer_logins|
      data = data.merge({bearer_logins: self.class.list(bearer_logins)})
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
