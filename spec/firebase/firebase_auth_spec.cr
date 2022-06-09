require "../spec_helper"

describe Google::FirebaseAuth do
  describe "#sign_up" do
    it "works in case of successful api call" do
      FirebaseAuthHelper.mock_token
      FirebaseAuthHelper.mock_sign_up

      expected = Google::FirebaseAuth::SignUpUserResponse.from_json(FirebaseAuthHelper.sign_up_response.to_json)
      received = FirebaseAuthHelper.firebase.sign_up(email: "test-user@example.com")
      received.should eq(expected)
    end
  end

  describe "#users" do
    it "works in case of successful api call" do
      FirebaseAuthHelper.mock_token
      FirebaseAuthHelper.mock_users

      expected = Google::FirebaseAuth::BatchUserResponse.from_json(FirebaseAuthHelper.users_response.to_json)
      received = FirebaseAuthHelper.firebase.users
      received.should eq(expected)
    end
  end

  describe "#delete" do
    it "works in case of successful api call" do
      FirebaseAuthHelper.mock_token
      FirebaseAuthHelper.mock_delete

      expected = Google::FirebaseAuth::DeleteUserResponse.from_json(FirebaseAuthHelper.delete_response.to_json)
      received = FirebaseAuthHelper.firebase.delete("local-id")
      received.should eq(expected)
    end
  end

  describe "#lookup" do
    it "works in case of successful api call" do
      FirebaseAuthHelper.mock_token
      FirebaseAuthHelper.mock_lookup

      expected = Google::FirebaseAuth::LookupUserResponse.from_json(FirebaseAuthHelper.lookup_response.to_json)
      received = FirebaseAuthHelper.firebase.lookup(["local-id"])
      received.should eq(expected)
    end
  end

  describe "#query" do
    it "works in case of successful api call" do
      FirebaseAuthHelper.mock_token
      FirebaseAuthHelper.mock_query

      expected = Google::FirebaseAuth::QueryUserResponse.from_json(FirebaseAuthHelper.query_response.to_json)
      received = FirebaseAuthHelper.firebase.query([{"email" => "test-user@example.com"}])
      received.should eq(expected)
    end
  end

  describe "#update" do
    it "works in case of successful api call" do
      FirebaseAuthHelper.mock_token
      FirebaseAuthHelper.mock_update

      expected = Google::FirebaseAuth::UpdateUserResponse.from_json(FirebaseAuthHelper.update_response.to_json)
      received = FirebaseAuthHelper.firebase.update("asdfghjklzxcvbnm", display_name: "Test User")
      received.should eq(expected)
    end
  end
end

module FirebaseAuthHelper
  extend self

  def mock_token
    WebMock.stub(:post, "https://www.googleapis.com/oauth2/v4/token")
      .to_return(body: {access_token: "test_token", expires_in: 3599, token_type: "Bearer"}.to_json)
  end

  def firebase
    Google::FirebaseAuth.new(auth: auth, project_id: "spec-project-id")
  end

  def sign_up_response
    {
      "email":   "test-user@example.com",
      "localId": "asdfghjklzxcvbnm",
    }
  end

  def mock_sign_up
    WebMock.stub(:post, "https://identitytoolkit.googleapis.com/v1/accounts:signUp")
      .to_return(body: sign_up_response.to_json)
  end

  def users_response
    {
      "users": [user_info],
    }
  end

  def mock_users
    WebMock.stub(:get, "https://identitytoolkit.googleapis.com/v1/projects/spec-project-id/accounts:batchGet?maxResults=500")
      .to_return(body: users_response.to_json)
  end

  def user_info
    {
      "localId":          "asdfghjklzxcvbnm",
      "email":            "test-user@example.com",
      "displayName":      "Test User",
      "emailVerified":    false,
      "providerUserInfo": [
        {
          "providerId":  "example.com",
          "displayName": "Test User",
          "federatedId": "ea5aafd911d22012",
          "email":       "test-user@example.com",
          "rawId":       "ea5aafd911d22012",
        },
      ],
      "validSince":    "1653541473",
      "disabled":      false,
      "lastLoginAt":   "1653541473015",
      "createdAt":     "1653541473014",
      "lastRefreshAt": "2022-05-26T05:04:33.015Z",
    }
  end

  def delete_response
    {} of String => String
  end

  def mock_delete
    WebMock.stub(:post, "https://identitytoolkit.googleapis.com/v1/projects/spec-project-id/accounts:delete")
      .to_return(body: delete_response.to_json)
  end

  def lookup_response
    users_response
  end

  def mock_lookup
    WebMock.stub(:post, "https://identitytoolkit.googleapis.com/v1/projects/spec-project-id/accounts:lookup")
      .to_return(body: lookup_response.to_json)
  end

  def query_response
    {
      "recordsCount": "1",
      "users":        [user_info],
    }
  end

  def mock_query
    WebMock.stub(:post, "https://identitytoolkit.googleapis.com/v1/projects/spec-project-id/accounts:query")
      .to_return(body: query_response.to_json)
  end

  def update_response
    {
      "localId":     "asdfghjklzxcvbnm",
      "email":       "test-user@example.com",
      "displayName": "Test User",
    }
  end

  def mock_update
    WebMock.stub(:post, "https://identitytoolkit.googleapis.com/v1/projects/spec-project-id/accounts:update")
      .to_return(body: update_response.to_json)
  end

  def auth
    Google::FileAuth.new(file_path: client_auth_file, scopes: "TEST_GOOGLE_API_SCOPE")
  end

  def client_auth_file
    File.expand_path("./spec/fixtures/client_auth.json")
  end
end
