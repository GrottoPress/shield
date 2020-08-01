class Shield::Error < Exception
  include Lucky::RenderableError

  def renderable_status : Int32
    403
  end

  def renderable_message : String
    message.to_s
  end
end
