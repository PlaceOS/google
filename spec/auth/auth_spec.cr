require "../spec_helper"

describe Google::Auth do
  describe "#get_token" do
    it "succeeds when everything goes well" do
      WebMock.stub(:post, "https://www.googleapis.com/oauth2/v4/token")
        .to_return(body: {access_token: "test_token", expires_in: 3599, token_type: "Bearer"}.to_json)

      auth = Google::Auth.new(issuer: "test@example.com", signing_key: AuthHelper.key, scopes: "TEST_GOOGLE_API_SCOPE")
      auth.get_token.access_token.should eq("test_token")
    end

    it "fails when api errors" do
      WebMock.stub(:post, "https://www.googleapis.com/oauth2/v4/token")
        .to_return(status: 500, body: "oops")

      auth = Google::Auth.new(issuer: "test@example.com", signing_key: AuthHelper.key, scopes: "TEST_GOOGLE_API_SCOPE", sub: "admin@example.com")
      expect_raises(Google::Exception, "Internal Server Error") do
        auth.get_token
      end
    end
  end
end

module AuthHelper
  extend self

  def key
    "-----BEGIN RSA PRIVATE KEY-----
MIICWgIBAAKBgH1rFiAsTRtg99/xdRLib32U03IxRFz93LMjjuxdGM+oGLLN9WmE
sXVLUNaTVTVNwyHhXjKU2In1fGzqO4samNSEuLMYbKjpUkn7VjpbVqN5Z9mEVgjZ
oXu0RBs+uMQqB1iq7amfBt9kKIIWiqypfyd+8SQu1icUZzoXxkBYMyjpAgMBAAEC
gYBfrPCNDJ6p0zhk+yLvjBO3PnBrfZAETJkvg2HFiGOkDj0BMkMUAukJbLI3bt+i
sTa5wt4EQi5KWB5aS/mubVTGQJq91Qo/mNFfdfjpdAiLrTPWpcDrXWUBPX5ycvIR
Ll79DzaQWQ7CHOiQsX2P7dB3mjn/BYz/Tw6e1joQ7spWAQJBAL9fytFMPNTQ0Ew4
MV3kKr/nYOGFeSuIcjY89avdfqf2gz0w6bDhuI3je5cXTWGX0ZnqhYYwUaNTE8NT
0Jc6f0ECQQCnxXCBS5W4QohWUhPsL5gULFjcNSXiMSbE0hKtTSQMY/FJ0E/08yI4
UZ+2qfHIK6LKemIOAhspjkZEbOki4mepAkB3V2BeVuGUgUd0UJKQj6oNFFg5Kwge
Gq/GnQtDCxRh3/uFnEwPLyPs79Bxr2llE8z04+gyf01ZwYQQieMJe8RBAkBi5qd9
8Prf1ojcqiIId74lFkeD+OjOQL9kA5rzAqifjUMuili4Q6QGo0eNvP1FTUP4LNEl
BOTSSIbvy2xcHi+RAkBl27EJAyYIBdwpQ2hxZ3rOyzp1PjQixZJP4LM7VRL+ThgF
F2/Xb2Zm0CiUE4XXK/WMCEhVPFKdxcEHBFCW7dN5
-----END RSA PRIVATE KEY-----"
  end
end
