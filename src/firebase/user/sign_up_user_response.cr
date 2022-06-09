module Google
  class FirebaseAuth
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

      @[JSON::Field(key: "expiresIn", converter: Google::StringTypeConverter(Int64))]
      getter expires_in : Int64?

      @[JSON::Field(key: "localId")]
      getter local_id : String
    end
  end
end
