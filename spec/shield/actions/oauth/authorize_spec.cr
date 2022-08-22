require "../../../spec_helper"

describe Shield::Oauth::Authorize do
  it "redirects request" do
    response = ApiClient.exec(Oauth::Authorize)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["Location"]?.should(eq Oauth::Authorization::New.path)
  end
end
