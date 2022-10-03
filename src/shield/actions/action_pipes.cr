module Shield::ActionPipes
  macro included
    after :set_previous_page_url

    def set_previous_page_url
      PageUrlSession.new(session).set(request)
      continue
    end
  end
end
