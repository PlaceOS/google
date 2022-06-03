require "connect-proxy"
require "json"
require "uri"

require "../auth/auth"
require "../auth/file_auth"
require "./user/*"

module Google
  class FirebaseAuth
    def initialize(@auth : Google::Auth | Google::FileAuth | String, @project_id : String, user_agent : String? = nil)
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

    # API details: https://cloud.google.com/identity-platform/docs/reference/rest/v1/projects.accounts/batchGet
    def users_request(limit = 500, **opts)
      opts = opts.merge({
        maxResults: limit,
      })
      options = opts.map { |key, value| "#{key}=#{value}" }.join("&")

      HTTP::Request.new("GET", "/v1/projects/#{@project_id}/accounts:batchGet?#{options}", HTTP::Headers{
        "Authorization" => "Bearer #{get_token}",
        "User-Agent"    => @user_agent,
      })
    end

    def users(response : HTTP::Client::Response)
      Google::Exception.raise_on_failure(response)
      BatchUserResponse.from_json response.body
    end

    def users(limit = 500, **opts)
      users perform(users_request(limit, **opts))
    end

    # API details: https://cloud.google.com/identity-platform/docs/reference/rest/v1/projects.accounts/delete
    def delete_request(local_id : String, **opts)
      opts = opts.merge({
        localId: local_id,
      })

      HTTP::Request.new("POST", "/v1/projects/#{@project_id}/accounts:delete", HTTP::Headers{
        "Authorization" => "Bearer #{get_token}",
        "User-Agent"    => @user_agent,
      }, opts.to_json)
    end

    def delete(response : HTTP::Client::Response)
      Google::Exception.raise_on_failure(response)
      DeleteUserResponse.from_json response.body
    end

    def delete(local_id : String, **opts)
      delete perform(delete_request(local_id, **opts))
    end

    # API details: https://cloud.google.com/identity-platform/docs/reference/rest/v1/projects.accounts/lookup
    def lookup_request(local_id : Array(String)? = nil, **opts)
      opts = opts.merge({localId: local_id}) if local_id

      HTTP::Request.new("POST", "/v1/projects/#{@project_id}/accounts:lookup", HTTP::Headers{
        "Authorization" => "Bearer #{get_token}",
        "User-Agent"    => @user_agent,
      }, opts.to_json)
    end

    def lookup(response : HTTP::Client::Response)
      Google::Exception.raise_on_failure(response)
      LookupUserResponse.from_json response.body
    end

    def lookup(local_id : Array(String)? = nil, **opts)
      lookup perform(lookup_request(local_id, **opts))
    end

    # API details: https://cloud.google.com/identity-platform/docs/reference/rest/v1/projects.accounts/query
    def query_request(expression, **opts)
      opts = opts.merge({
        expression: expression,
      })

      HTTP::Request.new("POST", "/v1/projects/#{@project_id}/accounts:query", HTTP::Headers{
        "Authorization" => "Bearer #{get_token}",
        "User-Agent"    => @user_agent,
      }, opts.to_json)
    end

    def query(response : HTTP::Client::Response)
      Google::Exception.raise_on_failure(response)
      QueryUserResponse.from_json response.body
    end

    def query(expression, **opts)
      query perform(query_request(expression, **opts))
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

    private def perform(request)
      ConnectProxy::HTTPClient.new(FIREBASE_AUTH_URI) do |client|
        client.exec(request)
      end
    end
  end
end
