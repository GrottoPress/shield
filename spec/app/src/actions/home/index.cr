class Home::Index < ApiAction
  get "/" do
    plain_text "Home::Index"
  end
end
