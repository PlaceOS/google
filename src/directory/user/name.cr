module Google
  class Directory
    class User
      class Name
        include JSON::Serializable

        @[JSON::Field(key: "givenName")]
        property given_name : String

        @[JSON::Field(key: "familyName")]
        property family_name : String

        @[JSON::Field(key: "fullName")]
        property full_name : String?
      end
    end
  end
end
