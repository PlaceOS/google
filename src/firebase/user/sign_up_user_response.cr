module Google
  class FirebaseAuth
    # API details: https://cloud.google.com/identity-platform/docs/reference/rest/v1/SignUpResponse
    class SignUpUserResponse
      include JSON::Serializable

      getter kind : String?

      @[JSON::Field(key: "idToken")]
      getter id_token : String?

      @[JSON::Field(key: "displayName")]
      getter display_name : String?

      getter email : String?

      @[JSON::Field(key: "refreshToken")]
      getter refresh_token : String?

      @[JSON::Field(key: "expiresIn", converter: Google::TimeSpanConverter)]
      getter expires_in : Time::Span?

      @[JSON::Field(key: "localId")]
      getter local_id : String
    end
  end
end
