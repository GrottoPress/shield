module Shield
  class NoAuthorizationError < Error
    def renderable_status : Int32
      503
    end
  end
end
