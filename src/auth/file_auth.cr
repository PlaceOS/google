require "./auth"
require "./token"

module Google
  class FileAuth
    getter :file_path, :scopes, :user_agent, :sub, :client_secret
    @client_secret : Hash(String, String)

    def initialize(@file_path : String, @scopes : String | Array(String), @sub : String = "", @user_agent : String = "Switch")
      @client_secret = process_auth_file
    end

    def get_token : Token
      Google::Auth.new(issuer: issuer, signing_key: signing_key, scopes: scopes, user_agent: user_agent, sub: sub).get_token
    end

    def signing_key : String
      client_secret["private_key"]
    end

    def client_email : String
      client_secret["client_email"]
    end

    def issuer : String
      client_secret["client_email"]
    end

    private def process_auth_file : Hash(String, String)
      raise "error reading file: #{file_path}" unless File.file?(file_path)

      auth_file = File.read(file_path)

      Hash(String, String).from_json(auth_file)
    end
  end
end
