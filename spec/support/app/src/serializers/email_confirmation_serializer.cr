struct EmailConfirmationSerializer < BaseSerializer
  def initialize(@email_confirmation : EmailConfirmation)
  end

  def render
    {type: self.class.name, id: @email_confirmation.id}
  end
end
