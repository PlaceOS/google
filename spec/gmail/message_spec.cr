require "../spec_helper"
require "email"

describe Google::Gmail::Messages do
  describe "#send" do
    it "works in case of successful api call" do
      MessageHelper.mock_token
      MessageHelper.mock_message_send

      user_id = "steve@place.os"

      email = EMail::Message.new
      email.from user_id
      email.to "to@example.com"
      email.subject "subject"
      email.message "hello gmail"

      MessageHelper.messages.send(user_id, email.to_s)
    end
  end
end

module MessageHelper
  extend self

  def mock_token
    WebMock.stub(:post, "https://www.googleapis.com/oauth2/v4/token")
      .to_return(body: {access_token: "test_token", expires_in: 3599, token_type: "Bearer"}.to_json)
  end

  def mock_message_send
    WebMock.stub(:post, "https://gmail.googleapis.com/upload/gmail/v1/users/steve@place.os/messages/send")
      .with(body: "{\"raw\":\"RnJvbTogc3RldmVAcGxhY2Uub3MKVG86IHRvQGV4YW1wbGUuY29tClN1YmplY3Q6IHN1YmplY3QKTWltZS1WZXJzaW9uOiAxLjAKQ29udGVudC1UeXBlOiB0ZXh0L3BsYWluOyBjaGFyc2V0PVVURi04OwpDb250ZW50LVRyYW5zZmVyLUVuY29kaW5nOiA3Yml0CgpoZWxsbyBnbWFpbA==\"}", headers: {"Authorization" => "Bearer test_token", "Content-Type" => "application/json"})

      # NOTE:: update this if we ever care to parse the response
      .to_return(body: "")
  end

  def messages
    Google::Gmail::Messages.new(auth: auth)
  end

  def auth
    Google::FileAuth.new(file_path: client_auth_file, scopes: "TEST_GOOGLE_API_SCOPE")
  end

  def client_auth_file
    File.expand_path("./spec/fixtures/client_auth.json")
  end
end
