require "../firebase_epoch_converter"
require "../firebase_epoch_millis_converter"
require "../firebase_time_format_converter"
require "./provider_user_info"

module Google
  class FirebaseAuth
    class User
      include JSON::Serializable

      getter email : String

      @[JSON::Field(key: "displayName")]
      getter display_name : String?

      getter language : String?

      @[JSON::Field(key: "photoUrl")]
      getter photo_url : String?

      @[JSON::Field(key: "timeZone")]
      getter time_zone : String?

      @[JSON::Field(key: "emailVerified")]
      getter email_verified : Bool

      @[JSON::Field(key: "providerUserInfo")]
      getter provider_user_info : Array(ProviderUserInfo)

      @[JSON::Field(key: "validSince", converter: Google::FirebaseAuth::EpochConverter)]
      getter valid_since : Time

      getter disabled : Bool?

      @[JSON::Field(key: "lastLoginAt", converter: Google::FirebaseAuth::EpochMillisConverter)]
      getter last_login_at : Time

      @[JSON::Field(key: "createdAt", converter: Google::FirebaseAuth::EpochMillisConverter)]
      getter created_at : Time

      @[JSON::Field(key: "lastRefreshAt", converter: Google::FirebaseAuth::TimeFormatConverter)]
      getter last_refresh_at : Time
    end
  end
end
