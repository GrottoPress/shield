module Shield::CreateOauthAccessTokenFromClient
  @[Deprecated("Use `#credentials` instead")]
  def refresh_token : String?
    credentials.try(&.to_s)
  end
end

module Shield::CreateOauthAccessTokenFromGrant
  @[Deprecated("Use `#credentials` instead")]
  def refresh_token : String?
    credentials.try(&.to_s)
  end
end

module Shield::RotateOauthGrant
  @[Deprecated("Use `#credentials` instead")]
  def refresh_token : String?
    credentials.try(&.to_s)
  end
end
