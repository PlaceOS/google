require "connect-proxy"
require "json"
require "uri"

require "../auth/auth"
require "../auth/file_auth"
require "../auth/get_token"
require "./user/*"

module Google
  # API details: https://cloud.google.com/identity-platform/docs/reference/rest
  class FirebaseAuth
    include Auth::GetToken

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

    ####################
    # Users - accounts #
    ####################

    # API details: https://cloud.google.com/identity-platform/docs/reference/rest/v1/accounts/signUp
    def sign_up_request(email : String? = nil, password : String? = nil, display_name : String? = nil, **opts)
      opts = opts.merge({
        targetProjectId: @project_id,
      })
      opts = opts.merge({email: email}) if email
      opts = opts.merge({password: password}) if password
      opts = opts.merge({displayName: display_name}) if display_name
      opts = transform_options(opts) if opts

      HTTP::Request.new("POST", "/v1/accounts:signUp", HTTP::Headers{
        "Authorization" => "Bearer #{get_token}",
        "User-Agent"    => @user_agent,
      }, opts.to_json)
    end

    def sign_up(response : HTTP::Client::Response)
      Google::Exception.raise_on_failure(response)
      SignUpUserResponse.from_json response.body
    end

    def sign_up(email : String? = nil, password : String? = nil, display_name : String? = nil, **opts)
      sign_up perform(sign_up_request(email, password, display_name, **opts))
    end

    #############################
    # Users - projects.accounts #
    #############################

    # API details: https://cloud.google.com/identity-platform/docs/reference/rest/v1/projects.accounts/batchGet
    def users_request(limit = 500, **opts)
      opts = opts.merge({
        maxResults: limit,
      })
      opts = transform_options(opts) if opts
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
      opts = transform_options(opts) if opts

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
      # opts = transform_options(opts) if opts

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
      opts = transform_options(opts) if opts

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

    # API details: https://cloud.google.com/identity-platform/docs/reference/rest/v1/projects.accounts/update
    def update_request(local_id : String, display_name : String? = nil, email : String? = nil, password : String? = nil, disable_user : Bool? = nil, **opts)
      opts = opts.merge({
        localId: local_id,
      })
      opts = opts.merge({displayName: display_name}) if display_name
      opts = opts.merge({email: email}) if email
      opts = opts.merge({password: password}) if password
      opts = opts.merge({disableUser: disable_user}) unless disable_user.nil?
      opts = transform_options(opts) if opts

      HTTP::Request.new("POST", "/v1/projects/#{@project_id}/accounts:update", HTTP::Headers{
        "Authorization" => "Bearer #{get_token}",
        "User-Agent"    => @user_agent,
      }, opts.to_json)
    end

    def update(response : HTTP::Client::Response)
      Google::Exception.raise_on_failure(response)
      UpdateUserResponse.from_json response.body
    end

    def update(local_id : String, display_name : String? = nil, email : String? = nil, password : String? = nil, disable_user : Bool? = nil, **opts)
      update perform(update_request(local_id, display_name, email, password, disable_user, **opts))
    end

    ###########
    # Helpers #
    ###########

    private def perform(request)
      ConnectProxy::HTTPClient.new(FIREBASE_AUTH_URI) do |client|
        client.exec(request)
      end
    end

    private def transform_options(args : NamedTuple | Hash) : Hash
      hash = args.is_a?(Hash) ? args : args.to_h
      hash.each.map do |key, value|
        value = if value.is_a?(NamedTuple) || value.is_a?(Hash)
                  transform_options(value)
                elsif value.is_a?(Array)
                  value.map { |v| v.is_a?(NamedTuple) || v.is_a?(Hash) ? transform_options(v) : v }
                else
                  value
                end
        {key.to_s.camelcase(lower: true), value}
      end.to_h
    end
  end
end
