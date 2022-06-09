require "./provider_user_info"

module Google
  class FirebaseAuth
    # API details: https://cloud.google.com/identity-platform/docs/reference/rest/v1/SetAccountInfoResponse
    class UpdateUserResponse
      include JSON::Serializable

      getter kind : String?

      @[JSON::Field(key: "localId")]
      getter local_id : String

      getter email : String?

      @[JSON::Field(key: "displayName")]
      getter display_name : String?

      @[JSON::Field(key: "idToken")]
      getter id_token : String?

      @[JSON::Field(key: "providerUserInfo")]
      getter provider_user_info : Array(ProviderUserInfo)?

      @[JSON::Field(key: "newEmail")]
      getter new_email : String?

      @[JSON::Field(key: "photoUrl")]
      getter photo_url : String?

      @[JSON::Field(key: "refreshToken")]
      getter refresh_token : String?

      @[JSON::Field(key: "expiresIn", converter: Google::StringTypeConverter(Int64))]
      getter expires_in : Int64?

      # fields left out
      # passwordHash

      @[JSON::Field(key: "emailVerified")]
      getter email_verified : Bool?
    end
  end
end
