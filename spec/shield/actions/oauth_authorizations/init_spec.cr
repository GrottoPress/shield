require "../../../spec_helper"

describe Shield::OauthAuthorizations::Init do
  it "redirects request" do
    response = ApiClient.exec(OauthAuthorizations::Init)

    response.status.should eq(HTTP::Status::FOUND)

    response.headers["Location"]?
      .should(eq CurrentUser::OauthAuthorizations::New.path)
  end
end
