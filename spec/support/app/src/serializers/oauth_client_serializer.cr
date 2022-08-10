struct OauthClientSerializer < SuccessSerializer
  def initialize(
    @oauth_client : OauthClient? = nil,
    @oauth_clients : Array(OauthClient)? = nil,
    @message : String? = nil,
    @pages : Lucky::Paginator? = nil,
    @secret : String? = nil,
    @user : User? = nil,
  )
  end

  def self.item(oauth_client : OauthClient)
    {type: oauth_client.class.name}
  end

  private def data_json : NamedTuple
    data = super
    data = add_oauth_client(data)
    data = add_oauth_clients(data)
    data = add_secret(data)
    data = add_user(data)
    data
  end

  private def add_oauth_client(data)
    @oauth_client.try do |oauth_client|
      data = data.merge({oauth_client: self.class.item(oauth_client)})
    end

    data
  end

  private def add_oauth_clients(data)
    @oauth_clients.try do |oauth_clients|
      data = data.merge({oauth_clients: self.class.list(oauth_clients)})
    end

    data
  end

  private def add_secret(data)
    @secret.try { |secret| data = data.merge({secret: secret }) }
    data
  end

  private def add_user(data)
    @user.try { |user| data = data.merge({user: UserSerializer.item(user)}) }
    data
  end
end
