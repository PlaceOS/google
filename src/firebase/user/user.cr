require "./provider_user_info"

module Google
  class FirebaseAuth
    # API details: https://cloud.google.com/identity-platform/docs/reference/rest/v1/UserInfo
    #
    # Fields left out:
    # - dateOfBirth
    # - passwordHash
    # - salt
    # - version
    # - mfaInfo
    struct User
      include JSON::Serializable

      @[JSON::Field(key: "localId")]
      getter local_id : String

      getter email : String?

      @[JSON::Field(key: "displayName")]
      getter display_name : String?

      getter language : String?

      @[JSON::Field(key: "photoUrl")]
      getter photo_url : String?

      @[JSON::Field(key: "timeZone")]
      getter time_zone : String?

      # dateOfBirth
      # passwordHash
      # salt
      # version

      @[JSON::Field(key: "emailVerified")]
      getter email_verified : Bool?

      @[JSON::Field(key: "passwordUpdatedAt", converter: Time::EpochMillisConverter)]
      getter password_updated_at : Time?

      @[JSON::Field(key: "providerUserInfo")]
      getter provider_user_info : Array(ProviderUserInfo)?

      @[JSON::Field(key: "validSince", converter: Google::EpochConverter)]
      getter valid_since : Time

      getter disabled : Bool

      @[JSON::Field(key: "lastLoginAt", converter: Google::EpochMillisConverter)]
      getter last_login_at : Time?

      @[JSON::Field(key: "createdAt", converter: Google::EpochMillisConverter)]
      getter created_at : Time

      @[JSON::Field(key: "screenName")]
      getter screen_name : String?

      @[JSON::Field(key: "customAuth")]
      getter custom_auth : Bool?

      @[JSON::Field(key: "rawPassword")]
      getter raw_password : String?

      @[JSON::Field(key: "phoneNumber")]
      getter phone_number : String?

      # JSON wrapped in a string
      # specifically Googles definition of valid JSON
      @[JSON::Field(key: "customAttributes")]
      getter custom_attributes : String?

      @[JSON::Field(key: "emailLinkSignin")]
      getter email_link_signin : Bool?

      @[JSON::Field(key: "tenantId")]
      getter tenant_id : String?

      # mfaInfo

      @[JSON::Field(key: "initialEmail")]
      getter initial_email : String?

      @[JSON::Field(key: "lastRefreshAt", converter: Google::RFC3339Converter)]
      getter last_refresh_at : Time?
    end
  end
end
