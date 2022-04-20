require "../../spec_helper"

describe Shield::ActionPipes do
  describe "#set_previous_page_url" do
    it "sets previous page URL" do
      client = ApiClient.new

      response = client.exec(Home::Index)
      response.should send_json(200, page: "Home::Index")
      response.should send_json(200, previous_page: nil)

      client.headers("Cookie": response.headers["Set-Cookie"]?)
      response = client.exec(About::Index)
      response.should send_json(200, page: "About::Index")
      response.should send_json(200, previous_page: Home::Index.path)

      client.headers("Cookie": response.headers["Set-Cookie"]?)
      response = client.exec(Home::Create)
      response.should send_json(200, page: "Home::Create")
      response.should send_json(200, previous_page: About::Index.path)

      client.headers("Cookie": response.headers["Set-Cookie"]?)
      response = client.exec(Home::Index)
      response.should send_json(200, page: "Home::Index")
      response.should send_json(200, previous_page: nil)

      client.headers("Cookie": response.headers["Set-Cookie"]?)
      response = client.exec(About::Index)
      response.should send_json(200, page: "About::Index")
      response.should send_json(200, previous_page: Home::Index.path)
    end
  end

  describe "#redirect_back" do
    it "redirects back" do
      client = ApiClient.new

      response = client.exec(Home::Index)
      response.should send_json(200, page: "Home::Index")

      client.headers("Cookie": response.headers["Set-Cookie"]?)
      response = client.exec(Home::Show)
      response.headers["Location"]?.should eq(Home::Index.path)
    end

    it "does not use previous page url for PATCH requests" do
      client = ApiClient.new

      response = client.exec(Home::Index)
      response.should send_json(200, page: "Home::Index")

      client.headers("Cookie": response.headers["Set-Cookie"]?)
      response = client.exec(Home::Update)
      response.headers["Location"]?.should eq(Home::Show.path)
    end

    it "does not use previous page url for POST requests" do
      client = ApiClient.new

      response = client.exec(Home::Index)
      response.should send_json(200, page: "Home::Index")

      client.headers("Cookie": response.headers["Set-Cookie"]?)
      response = client.exec(About::Create)
      response.headers["Location"]?.should eq(Home::Show.path)
    end

    it "does not use previous page url for PUT requests" do
      client = ApiClient.new

      response = client.exec(Home::Index)
      response.should send_json(200, page: "Home::Index")

      client.headers("Cookie": response.headers["Set-Cookie"]?)
      response = client.exec(About::Update)
      response.headers["Location"]?.should eq(Home::Show.path)
    end

    it "does not use the referrer URL" do
      client = ApiClient.new

      response = client.exec(Home::Index)
      response.should send_json(200, page: "Home::Index")

      client.headers("Cookie": response.headers["Set-Cookie"]?)
      client.headers("Referer": "http://abc.def/gh")
      response = client.exec(Home::Edit)
      response.headers["Location"]?.should eq(Home::Index.path)
    end
  end
end
