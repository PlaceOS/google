require "oauth2"
require "./token"

module Google
  class TokenAuth < Auth
    @access_token : String
    @expires_at : Int64
    @refresh_token : String? = nil

    def initialize(@access_token : String, @expires_at : Int64, @user_agent : String = DEFAULT_USER_AGENT)
    end

    def initialize(refresh_token : String, @access_token : String, @expires_at : Int64, @user_agent : String = DEFAULT_USER_AGENT)
      @refresh_token = refresh_token
    end

    def get_token : Token
      use_refresh_token if expired?
      Token.new(@access_token, Time.unix(@expires_at), @refresh_token)
    end

    def issuer : String
      raise NotImplementedError.new("not supported using an access token directly")
    end

    def signing_key : String
      raise NotImplementedError.new("not supported using an access token directly")
    end

    def client_email : String
      raise NotImplementedError.new("not supported using an access token directly")
    end

    protected def expired?
      5.seconds.from_now.to_unix > @expires_at
    end

    protected def use_refresh_token
      refresh_token = @refresh_token
      raise "access token expired" unless refresh_token

      oauth2_client = OAuth2::Client.new("oauth2.googleapis.com", client_id: "", client_secret: "", token_uri: "/token")
      token = oauth2_client.get_access_token_using_refresh_token(refresh_token)

      if expires_in = token.expires_in
        @expires_at = Time.utc.to_unix + expires_in
      else
        @expires_at = 5.years.from_now.to_unix
      end
      @access_token = token.access_token
      @refresh_token = token.refresh_token
    end
  end
end
