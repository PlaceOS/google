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

    def initialize(@auth : Google::Auth | Google::FileAuth, user_agent : String? = nil)
      @user_agent = user_agent || @auth.user_agent
    end

    def files
      response = ConnectProxy::HTTPClient.new(GOOGLE_URI) do |client|
        client.exec("GET", "/drive/v3/files", HTTP::Headers{
          "Authorization" => "Bearer #{get_token}",
          "User-Agent"    => @user_agent,
        })
      end

      raise "error listing files - #{response.status} (#{response.status_code})\n#{response.body}" unless response.success?

      Files::List.from_json response.body
    end

    def file(id : String)
      response = ConnectProxy::HTTPClient.new(GOOGLE_URI) do |client|
        client.exec("GET", "/drive/v3/files/#{id}?fields=webContentLink,id,name", HTTP::Headers{
          "Authorization" => "Bearer #{get_token}",
          "User-Agent"    => @user_agent,
        })
      end

      raise "error fetching file - #{response.status} (#{response.status_code})\n#{response.body}" unless response.success?
      Files::DriveFile.from_json response.body
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

      raise "error creating file - #{response.status} (#{response.status_code})\n#{response.body}" unless response.success?
      Files::DriveFile.from_json response.body
    end

    def delete(id : String)
      response = ConnectProxy::HTTPClient.new(GOOGLE_URI) do |client|
        client.exec("DELETE", "/drive/v3/files/#{id}", HTTP::Headers{
          "Authorization" => "Bearer #{get_token}",
          "User-Agent"    => @user_agent,
        })
      end

      raise "error fetching file - #{response.status} (#{response.status_code})\n#{response.body}" unless response.success?
      true
    end

    private def get_token
      @auth.get_token.access_token
    end
  end
end
