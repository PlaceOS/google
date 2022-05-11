require "connect-proxy"
require "http"
require "jwt"
require "json"
require "uri"

require "./token"

module Google
  abstract class Auth
    DEFAULT_USER_AGENT = "Google on Crystal"
    property user_agent : String = DEFAULT_USER_AGENT

    def self.new(issuer : String, signing_key : String, scopes : String | Array(String), sub : String = "", user_agent : String = DEFAULT_USER_AGENT)
      ServiceAuth.new(issuer, signing_key, scopes, sub, user_agent)
    end

    abstract def get_token : Token
    abstract def issuer : String
    abstract def signing_key : String
    abstract def client_email : String
  end
end

require "./service_auth"
require "./token_auth"
require "./file_auth"
