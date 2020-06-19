require "connect-proxy"
require "http"
require "jwt"
require "json"
require "uri"

require "./token"

module Google
  class Auth
    GOOGLE_URI = URI.parse("https://www.googleapis.com")
    TOKEN_PATH = "/oauth2/v4/token"

    AUDIENCE = "https://www.googleapis.com/oauth2/v4/token"

    SIGNING_ALGORITHM = JWT::Algorithm::RS256
    EXPIRY            = 60.seconds
    TOKENS_CACHE      = {} of String => Token

    @scopes : String
    property user_agent : String

    def initialize(@issuer : String, @signing_key : String, scopes : String | Array(String), @sub : String = "", @user_agent : String = "Google on Crystal")
      @scopes = scopes.is_a?(Array) ? scopes.join(", ") : scopes
    end

    # https://developers.google.com/identity/protocols/OAuth2ServiceAccount
    def get_token : Token
      existing = TOKENS_CACHE[token_lookup]?
      return existing if existing && existing.current?

      response = ConnectProxy::HTTPClient.new(GOOGLE_URI) do |client|
        client.exec(
          "POST",
          TOKEN_PATH,
          HTTP::Headers{
            "Content-Type" => "application/x-www-form-urlencoded",
            "User-Agent"   => @user_agent,
          },
          "grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer&assertion=#{jwt_token}"
        )
      end
      Google::Exception.raise_on_failure(response)

      token = Token.from_json response.body
      token.expires = token.expires + token.expires_in.seconds - EXPIRY
      TOKENS_CACHE[token_lookup] = token

      token
    end

    private def assertion
      now = Time.local
      result = {
        "iss"   => @issuer,
        "scope" => @scopes,
        "aud"   => AUDIENCE,
        "iat"   => (now - EXPIRY).to_unix,
        "exp"   => (now + EXPIRY).to_unix,
      }

      result["sub"] = @sub unless @sub.empty?

      result
    end

    private def token_lookup
      "#{@scopes}_#{@sub}"
    end

    private def jwt_token
      JWT.encode(assertion, @signing_key, SIGNING_ALGORITHM)
    end
  end
end
