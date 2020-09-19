class ErrorSerializer < BaseSerializer
  def initialize(
    @message : String,
    @details : String? = nil,
    @param : String? = nil
  )
  end

  def render
    {message: @message, param: @param, details: @details}
  end
end
