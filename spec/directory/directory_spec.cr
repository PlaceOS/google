require "../spec_helper"

describe Google::Directory do
  describe "#users" do
    it "works in case of successful api call" do
      DirectoryHelper.mock_token
      DirectoryHelper.mock_user_query

      expected = Google::Directory::UserQuery.from_json(DirectoryHelper.user_query_response.to_json).to_json
      received = DirectoryHelper.directory.users.to_json
      received.should eq(expected)
    end
  end

  describe "#lookup" do
    it "works in case of successful api call" do
      DirectoryHelper.mock_token
      DirectoryHelper.mock_lookup

      expected = Google::Directory::User.from_json(DirectoryHelper.user_lookup_response.to_json).to_json
      received = DirectoryHelper.directory.lookup("test@example.com").to_json
      received.should eq(expected)
    end
  end

  describe "#groups" do
    it "works in case of successful api call" do
      DirectoryHelper.mock_token
      DirectoryHelper.mock_group_query

      expected = Google::Directory::GroupQuery.from_json(DirectoryHelper.group_query_response.to_json).to_json
      received = DirectoryHelper.directory.groups("steve@place.org").to_json
      received.should eq(expected)
    end
  end
end

module DirectoryHelper
  extend self

  def mock_token
    WebMock.stub(:post, "https://www.googleapis.com/oauth2/v4/token")
      .to_return(body: {access_token: "test_token", expires_in: 3599, token_type: "Bearer"}.to_json)
  end

  def directory
    Google::Directory.new(auth: auth, domain: "example.com")
  end

  def user_query_response
    {
      "kind":  "admin#directory#users",
      "users": [user_lookup_response],
    }
  end

  def mock_user_query
    WebMock.stub(:get, "https://www.googleapis.com/admin/directory/v1/users?domain=example.com&maxResults=500&projection=full&viewType=admin_view")
      .to_return(body: user_query_response.to_json)
  end

  def mock_lookup
    WebMock.stub(:get, "https://www.googleapis.com/admin/directory/v1/users/test@example.com?projection=full&viewType=admin_view")
      .to_return(body: user_lookup_response.to_json)
  end

  def user_lookup_response
    {
      "primaryEmail":               "test@example.com",
      "isAdmin":                    false,
      "isDelegatedAdmin":           false,
      "creationTime":               Time.utc,
      "agreedToTerms":              true,
      "suspended":                  false,
      "changePasswordAtNextLogin":  false,
      "includeInGlobalAddressList": false,
      "ipWhitelisted":              true,
      "isMailboxSetup":             true,
      "name":                       {
        "givenName":  "John",
        "familyName": "Smith",
        "fullName":   "John Smith",
      },
      "emails": [
        {
          "address": "test@example.com",
        },
      ],
    }
  end

  def group_lookup_response
    {
      "kind":               "admin#directory#group",
      "id":                 "string",
      "etag":               "etag",
      "email":              "string@domain",
      "name":               "string",
      "directMembersCount": 12,
      "description":        "string",
    }
  end

  def group_query_response
    {
      "kind":   "admin#directory#groups",
      "groups": [group_lookup_response],
    }
  end

  def mock_group_query
    WebMock.stub(:get, "https://www.googleapis.com/admin/directory/v1/groups/?userKey=steve@place.org")
      .to_return(body: group_query_response.to_json)
  end

  def auth
    Google::FileAuth.new(file_path: client_auth_file, scopes: "TEST_GOOGLE_API_SCOPE")
  end

  def client_auth_file
    File.expand_path("./spec/fixtures/client_auth.json")
  end
end
