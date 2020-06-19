require "../spec_helper"

describe Google::FileAuth do
  describe "#get_token" do
    it "succeeds" do
      WebMock.stub(:post, "https://www.googleapis.com/oauth2/v4/token")
        .to_return(body: {access_token: "test_token", expires_in: 3599, token_type: "Bearer"}.to_json)

      auth = Google::FileAuth.new(file_path: FileAuthHelper.client_auth_file, scopes: "TEST_GOOGLE_API_SCOPE")
      auth.get_token.access_token.should eq("test_token")
    end

    describe "failure" do
      it "api error" do
        WebMock.stub(:post, "https://www.googleapis.com/oauth2/v4/token")
          .to_return(status: 500, body: "oops")

        auth = Google::FileAuth.new(file_path: FileAuthHelper.client_auth_file, scopes: "TEST_GOOGLE_API_SCOPE", sub: "admin@example.com")
        expect_raises(Google::Exception, "Internal Server Error") do
          auth.get_token
        end
      end

      it "auth file does not have required fields" do
        auth = Google::FileAuth.new(file_path: FileAuthHelper.incomplete_client_auth_file, scopes: "TEST_GOOGLE_API_SCOPE", sub: "admin2@example.com")

        expect_raises(KeyError) do
          auth.get_token
        end
      end
    end
  end
end

module FileAuthHelper
  extend self

  def client_auth_file
    File.expand_path("./spec/fixtures/client_auth.json")
  end

  def incomplete_client_auth_file
    File.expand_path("./spec/fixtures/incomplete_client_auth.json")
  end
end
