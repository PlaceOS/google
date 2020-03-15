require "connect-proxy"
require "json"
require "uri"

require "../auth/auth"
require "../auth/file_auth"
require "./location"
require "./user/user"
require "./user/user_query"

module Google
  class Directory
    def initialize(@auth : Google::Auth | Google::FileAuth, @domain : String, @projection : String = "full", @view_type : String = "admin_view", user_agent : String? = nil)
      @user_agent = user_agent || @auth.user_agent
    end

    @user_agent : String

    # API details: https://developers.google.com/admin-sdk/directory/v1/reference/users/list
    def users(query = nil, limit = 500, **opts)
      opts = opts.merge({
        domain:     @domain,
        maxResults: limit,
        projection: @projection,
        viewType:   @view_type,
      })
      opts = opts.merge({query: query}) if query
      options = opts.map { |key, value| "#{key}=#{value}" }.join("&")

      response = ConnectProxy::HTTPClient.new(GOOGLE_URI) do |client|
        client.exec(
          "GET",
          "/admin/directory/v1/users?#{options}",
          HTTP::Headers{
            "Authorization" => "Bearer #{get_token}",
            "User-Agent"    => @user_agent,
          }
        )
      end

      raise "error fetching users from #{@domain} - #{response.status} (#{response.status_code})\n#{response.body}" unless response.success?
      UserQuery.from_json response.body
    end

    # https://developers.google.com/admin-sdk/directory/v1/reference/users/get
    def lookup(user_id)
      response = ConnectProxy::HTTPClient.new(GOOGLE_URI) do |client|
        client.exec(
          "GET",
          "/admin/directory/v1/users/#{user_id}?projection=#{@projection}&viewType=#{@view_type}",
          HTTP::Headers{
            "Authorization" => "Bearer #{get_token}",
            "User-Agent"    => @user_agent,
          }
        )
      end

      raise "error requesting user #{user_id} - #{response.status} (#{response.status_code})\n#{response.body}" unless response.success?
      User.from_json response.body
    end

    private def get_token
      @auth.get_token.access_token
    end
  end
end
