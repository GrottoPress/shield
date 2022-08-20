module Shield::ReturnUrlSession
  macro included
    def initialize(@session : Lucky::Session)
    end

    def return_url : String
      return_url?.not_nil!
    end

    def return_url? : String?
      @session.get?(:return_url).try do |url|
        delete
        url
      end
    end

    def delete : self
      @session.delete(:return_url)
      self
    end

    def set(request : HTTP::Request) : self
      if request.method.in?({"GET", "HEAD"})
        set(request.resource)
      else
        delete
      end
    end

    def set(url : String) : self
      @session.set(:return_url, url)
      self
    end
  end
end
