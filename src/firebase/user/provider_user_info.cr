module Google
  class FirebaseAuth
    class ProviderUserInfo
      include JSON::Serializable

      @[JSON::Field(key: "providerId")]
      getter provider_id : String

      @[JSON::Field(key: "displayName")]
      getter display_name : String?

      @[JSON::Field(key: "photoUrl")]
      getter photo_url : String?

      @[JSON::Field(key: "federatedId")]
      getter federated_id : String

      getter email : String

      @[JSON::Field(key: "rawId")]
      getter raw_id : String

      @[JSON::Field(key: "screenName")]
      getter screen_name : String?

      @[JSON::Field(key: "phoneNumber")]
      getter phone_number : String?
    end
  end
end
