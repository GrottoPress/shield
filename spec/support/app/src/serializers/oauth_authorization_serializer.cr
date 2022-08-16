struct OauthAuthorizationSerializer < SuccessSerializer
  def initialize(
    @oauth_authorization : OauthAuthorization? = nil,
    @oauth_authorizations : Array(OauthAuthorization)? = nil,
    @message : String? = nil,
    @pages : Lucky::Paginator? = nil,
    @user : User? = nil,
  )
  end

  def self.item(oauth_authorization : OauthAuthorization)
    {type: oauth_authorization.class.name}
  end

  private def data_json : NamedTuple
    data = super
    data = add_oauth_authorization(data)
    data = add_oauth_authorizations(data)
    data = add_user(data)
    data
  end

  private def add_oauth_authorization(data)
    @oauth_authorization.try do |oauth_authorization|
      data = data.merge({
        oauth_authorization: self.class.item(oauth_authorization)
      })
    end

    data
  end

  private def add_oauth_authorizations(data)
    @oauth_authorizations.try do |oauth_authorizations|
      data = data.merge({
        oauth_authorizations: self.class.list(oauth_authorizations)
      })
    end

    data
  end

  private def add_user(data)
    @user.try { |user| data = data.merge({user: UserSerializer.item(user)}) }
    data
  end
end
