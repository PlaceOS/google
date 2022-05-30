require "./provider_user_info"

module Google
  class FirebaseAuth
    class User
      include JSON::Serializable

      property email : String

      @[JSON::Field(key: "displayName")]
      property display_name : String?

      property language : String?

      @[JSON::Field(key: "photoUrl")]
      property photo_url : String?

      @[JSON::Field(key: "timeZone")]
      property time_zone : String?

      @[JSON::Field(key: "emailVerified")]
      property email_verified : Bool

      @[JSON::Field(key: "providerUserInfo")]
      property provider_user_info : Array(ProviderUserInfo)

      @[JSON::Field(key: "validSince")]
      property valid_since : String # Int64

      property disabled : Bool?

      @[JSON::Field(key: "lastLoginAt")]
      property last_login_at : String # Int64

      @[JSON::Field(key: "createdAt")]
      property created_at : String # Int64

      @[JSON::Field(key: "lastRefreshAt")]
      property last_refresh_at : String # Time
    end
  end
end
