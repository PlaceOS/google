require "connect-proxy"
require "json"
require "uri"

require "../auth/auth"
require "../auth/file_auth"
require "./location"
require "./user/*"
require "./group/*"

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
    def users_request(query = nil, limit = 500, **opts)
      opts = opts.merge({
        domain:     @domain,
        maxResults: limit,
        projection: @projection,
        viewType:   @view_type,
      })
      opts = opts.merge({query: URI.encode(query)}) if query
      options = opts.map { |key, value| "#{key}=#{value}" }.join("&")

      HTTP::Request.new("GET", "/admin/directory/v1/users?#{options}", HTTP::Headers{
        "Authorization" => "Bearer #{get_token}",
        "User-Agent"    => @user_agent,
      })
    end

    def users(response : HTTP::Client::Response)
      Google::Exception.raise_on_failure(response)
      UserQuery.from_json response.body
    end

    def users(query = nil, limit = 500, **opts)
      response = ConnectProxy::HTTPClient.new(GOOGLE_URI) do |client|
        client.exec(users_request(query, limit, **opts))
      end
      users(response)
    end

    # https://developers.google.com/admin-sdk/directory/v1/reference/users/get
    def lookup_request(user_id)
      HTTP::Request.new(
        "GET",
        "/admin/directory/v1/users/#{user_id}?projection=#{@projection}&viewType=#{@view_type}",
        HTTP::Headers{
          "Authorization" => "Bearer #{get_token}",
          "User-Agent"    => @user_agent,
        }
      )
    end

    def lookup(response : HTTP::Client::Response)
      Google::Exception.raise_on_failure(response)
      User.from_json response.body
    end

    def lookup(user_id)
      response = ConnectProxy::HTTPClient.new(GOOGLE_URI) do |client|
        client.exec(lookup_request(user_id))
      end
      lookup(response)
    end

    # https://developers.google.com/admin-sdk/directory/v1/reference/groups/list
    def groups_request(user_id = nil, **opts)
      opts = opts.merge({userKey: user_id}) if user_id
      options = opts.map { |key, value| "#{key}=#{value}" }.join("&")

      HTTP::Request.new(
        "GET",
        "/admin/directory/v1/groups/?#{options}",
        HTTP::Headers{
          "Authorization" => "Bearer #{get_token}",
          "User-Agent"    => @user_agent,
        }
      )
    end

    def groups(response : HTTP::Client::Response)
      Google::Exception.raise_on_failure(response)
      GroupQuery.from_json response.body
    end

    def groups(user_id = nil, **opts)
      response = ConnectProxy::HTTPClient.new(GOOGLE_URI) do |client|
        client.exec(groups_request(user_id, **opts))
      end
      groups(response)
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
