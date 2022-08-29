struct OauthGrantSerializer < SuccessSerializer
  def initialize(
    @oauth_grant : OauthGrant? = nil,
    @oauth_grants : Array(OauthGrant)? = nil,
    @message : String? = nil,
    @pages : Lucky::Paginator? = nil,
    @user : User? = nil,
  )
  end

  def self.item(oauth_grant : OauthGrant)
    {type: oauth_grant.class.name}
  end

  private def data_json : NamedTuple
    data = super
    data = add_oauth_grant(data)
    data = add_oauth_grants(data)
    data = add_user(data)
    data
  end

  private def add_oauth_grant(data)
    @oauth_grant.try do |oauth_grant|
      data = data.merge({oauth_grant: self.class.item(oauth_grant)})
    end

    data
  end

  private def add_oauth_grants(data)
    @oauth_grants.try do |oauth_grants|
      data = data.merge({oauth_grants: self.class.list(oauth_grants)})
    end

    data
  end

  private def add_user(data)
    @user.try { |user| data = data.merge({user: UserSerializer.item(user)}) }
    data
  end
end
