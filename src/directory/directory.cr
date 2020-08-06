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
    def initialize(auth : Google::Auth | Google::FileAuth | String, @domain : String, @projection : String = "full", @view_type : String = "admin_view", user_agent : String? = nil)
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

    @user_agent : String

    # API details: https://developers.google.com/admin-sdk/directory/v1/reference/users/list
    def users(query = nil, limit = 500, **opts)
      opts = opts.merge({
        domain:     @domain,
        maxResults: limit,
        projection: @projection,
        viewType:   @view_type,
      })
      opts = opts.merge({query: URI.encode(query)}) if query
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
      Google::Exception.raise_on_failure(response)

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
      Google::Exception.raise_on_failure(response)

      User.from_json response.body
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
