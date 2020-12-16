require "connect-proxy"
require "json"
require "uri"

require "../auth/auth"
require "../auth/file_auth"
require "./location"
require "./member"
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
      users perform(users_request(query, limit, **opts))
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
      lookup perform(lookup_request(user_id))
    end

    # https://developers.google.com/admin-sdk/directory/v1/reference/groups/list
    def groups_request(user_id = nil, **opts)
      opts = opts.merge({userKey: user_id}) if user_id
      options = opts.map { |key, value| "#{key}=#{value}" }.join("&")

      HTTP::Request.new(
        "GET",
        "/admin/directory/v1/groups/?maxResults=200&#{options}",
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
      groups perform(groups_request(user_id, **opts))
    end

    enum Role
      OWNER
      MANAGER
      MEMBER
    end

    # https://developers.google.com/admin-sdk/directory/reference/rest/v1/members/list
    def members_request(group_id : String, include_indirect : Bool = true, role : Role? = nil)
      options = "includeDerivedMembership=#{include_indirect}&maxResults=200"
      options += "roles=#{role.to_s}" if role

      HTTP::Request.new(
        "GET",
        "/admin/directory/v1/groups/#{group_id}/members?#{options}",
        HTTP::Headers{
          "Authorization" => "Bearer #{get_token}",
          "User-Agent"    => @user_agent,
        }
      )
    end

    def members(response : HTTP::Client::Response)
      Google::Exception.raise_on_failure(response)
      MemberQuery.from_json response.body
    end

    def members(group_id : String, include_indirect : Bool = true, role : Role? = nil)
      request = members_request(group_id, include_indirect, role)
      results = members(perform(request))

      request_uri = request.resource
      next_page = results.next_page_token

      loop do
        break unless next_page

        response = ConnectProxy::HTTPClient.new(GOOGLE_URI) do |client|
          client.exec(
            "GET",
            "#{request_uri}&pageToken=#{next_page}",
            HTTP::Headers{
              "Authorization" => "Bearer #{get_token}",
              "User-Agent"    => @user_agent,
            }
          )
        end

        # Append the results
        next_results = members(response)
        results.members.concat(next_results.members)
        next_page = next_results.next_page_token
      end

      results
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
      ConnectProxy::HTTPClient.new(GOOGLE_URI) do |client|
        client.exec(request)
      end
    end
  end
end
