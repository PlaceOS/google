require "connect-proxy"
require "json"
require "uri"

require "../auth/auth"
require "../auth/file_auth"

module Google
  class Directory
    GOOGLE_URI = URI.parse("https://www.googleapis.com")

    def initialize(@auth : Google::Auth | Google::FileAuth, @domain : String, @projection : String = "full", @view_type : String = "admin_view", @user_agent : String = "Switch")
    end

    def sub=(user)
      @auth.sub = user.not_nil!
    end

    def get_token
      @auth.get_token.access_token
    end

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

    class UserQuery
      include JSON::Serializable

      property kind : String
      property users : Array(User)
      property nextPageToken : String?
    end

    class User
      include JSON::Serializable

      class Name
        include JSON::Serializable

        property givenName : String
        property familyName : String
        property fullName : String?
      end

      class Email
        include JSON::Serializable

        property address : String
        property type : String?
        property customType : String?
        property primary : Bool?
      end

      class Relation
        include JSON::Serializable

        property value : String
        property type : String
        property customType : String?
      end

      class Address
        include JSON::Serializable

        property type : String
        property customType : String?
        property sourceIsStructured : Bool?
        property formatted : String?
        property poBox : String?
        property extendedAddress : String?
        property streetAddress : String?
        property locality : String
        property region : String?
        property postalCode : String?
        property country : String?
        property primary : Bool?
        property countryCode : String?
      end

      class Organization
        include JSON::Serializable

        property name : String?
        property title : String
        property primary : Bool?
        property type : String?
        property customType : String?
        property department : String?
        property symbol : String?
        property location : String?
        property description : String?
        property domain : String?
        property costCenter : String?
        property fullTimeEquivalent : Int32?
      end

      class Phone
        include JSON::Serializable

        property value : String
        property primary : Bool?
        property type : String
        property customType : String?
      end

      class Language
        include JSON::Serializable

        property languageCode : String
        property customLanguage : String?
      end

      class Gender
        include JSON::Serializable

        property type : String
        property customGender : String?
        property addressMeAs : String?
      end

      class Location
        include JSON::Serializable

        property type : String
        property customType : String?
        property area : String?
        property buildingId : String?
        property floorName : String?
        property floorSection : String?
        property deskCode : String?
      end

      # Optional for creating a user
      property kind : String?
      property id : String?
      property etag : String?
      property primaryEmail : String
      property isAdmin : Bool
      property isDelegatedAdmin : Bool
      property lastLoginTime : Time?
      property creationTime : Time
      property deletionTime : Time?
      property agreedToTerms : Bool
      property password : String?
      property hashFunction : String?
      property suspended : Bool

      property suspensionReason : String?
      property archived : Bool?
      property changePasswordAtNextLogin : Bool
      property ipWhitelisted : Bool

      property emails : Array(Email)
      property relations : Array(Relation)?
      property externalIds : Array(Relation)?
      property addresses : Array(Address)?
      property organizations : Array(Organization)?
      property phones : Array(Phone)?
      property languages : Array(Language)?
      property aliases : Array(String)?
      property nonEditableAliases : Array(String)?
      property notes : NamedTuple(value: String, contentType: String?)?
      property websites : Array(Phone)?
      property locations : Array(Location)?
      property keywords : Array(Relation)?
      property gender : Gender?

      property customerId : String?
      property orgUnitPath : String?
      property isMailboxSetup : Bool
      property isEnrolledIn2Sv : Bool?
      property isEnforcedIn2Sv : Bool?
      property includeInGlobalAddressList : Bool
      property thumbnailPhotoUrl : String?
      property thumbnailPhotoEtag : String?

      property customSchemas : Hash(String, Hash(String, String))?
    end
  end
end
