require "connect-proxy"
require "json"
require "uri"

require "../auth/auth"
require "../auth/file_auth"
require "./drive_file"
require "./list"

module Google
  class Files
    @user_agent : String

    def initialize(auth : Google::Auth | Google::FileAuth | String, user_agent : String? = nil)
      @auth = auth
      # If user agent not provided, then use the auth.user_agent
      # if a token was passed in directly then use the default agent string
      agent = user_agent || case auth
      in Google::Auth, Google::FileAuth
        auth.user_agent
      in String
        Google::Auth::DEFAULT_USER_AGENT
      end
      @user_agent = agent
    end

    def files
      response = ConnectProxy::HTTPClient.new(GOOGLE_URI) do |client|
        client.exec("GET", "/drive/v3/files?fields=*", HTTP::Headers{
          "Authorization" => "Bearer #{get_token}",
          "User-Agent"    => @user_agent,
        })
      end
      Google::Exception.raise_on_failure(response)

      Files::List.from_json response.body
    end

    def file(id : String)
      response = ConnectProxy::HTTPClient.new(GOOGLE_URI) do |client|
        client.exec("GET", "/drive/v3/files/#{id}?fields=*", HTTP::Headers{
          "Authorization" => "Bearer #{get_token}",
          "User-Agent"    => @user_agent,
        })
      end
      Google::Exception.raise_on_failure(response)

      Files::DriveFile.from_json response.body
    end

    def download_file(id : String)
      response = ConnectProxy::HTTPClient.new(GOOGLE_URI) do |client|
        client.exec("GET", "/drive/v3/files/#{id}?alt=media&fields=*", HTTP::Headers{
          "Authorization" => "Bearer #{get_token}",
          "User-Agent"    => @user_agent,
        })
      end
      Google::Exception.raise_on_failure(response)

      response.body
    end

    def create(name : String, content_bytes : String, content_type : String)
      body = Google::Files::DriveFile.new(name).body(content_bytes: content_bytes, content_type: content_type)
      response = ConnectProxy::HTTPClient.new(GOOGLE_URI) do |client|
        client.exec("POST", "/upload/drive/v3/files?uploadType=multipart", HTTP::Headers{
          "Authorization" => "Bearer #{get_token}",
          "Content-Type"  => "multipart/related; boundary=boundary",
          "User-Agent"    => @user_agent,
        },
          body)
      end
      Google::Exception.raise_on_failure(response)

      Files::DriveFile.from_json response.body
    end

    def delete(id : String)
      response = ConnectProxy::HTTPClient.new(GOOGLE_URI) do |client|
        client.exec("DELETE", "/drive/v3/files/#{id}", HTTP::Headers{
          "Authorization" => "Bearer #{get_token}",
          "User-Agent"    => @user_agent,
        })
      end
      Google::Exception.raise_on_failure(response)

      true
    end

    private def get_token : String
      auth = @auth
      case auth
      in Google::Auth, Google::FileAuth
        auth.get_token.access_token
      in String
        auth
      end
    end
  end
end
