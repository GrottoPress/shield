struct EmailConfirmationSerializer < SuccessSerializer
  def initialize(
    @email_confirmation : EmailConfirmation? = nil,
    @email_confirmations : Array(EmailConfirmation)? = nil,
    @message : String? = nil,
    @pages : Lucky::Paginator? = nil,
    @token : String? = nil,
    @user : User? = nil,
  )
  end

  def self.item(email_confirmation : EmailConfirmation)
    {type: email_confirmation.class.name}
  end

  private def data_json : NamedTuple
    data = super
    data = add_email_confirmation(data)
    data = add_email_confirmations(data)
    data = add_token(data)
    data = add_user(data)
    data
  end

  private def add_email_confirmation(data)
    @email_confirmation.try do |email_confirmation|
      data = data.merge({
        email_confirmation: self.class.item(email_confirmation)
      })
    end

    data
  end

  private def add_email_confirmations(data)
    @email_confirmations.try do |email_confirmations|
      data = data.merge({
        email_confirmations: self.class.list(email_confirmations)
      })
    end

    data
  end

  private def add_token(data)
    @token.try { |token| data = data.merge({token: token }) }
    data
  end

  private def add_user(data)
    @user.try { |user| data = data.merge({user: UserSerializer.item(user) }) }
    data
  end
end
