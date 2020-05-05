module Google
  class Directory
    class User
      class Email
        include JSON::Serializable

        property address : String
        property type : String?

        @[JSON::Field(key: "customType")]
        property custom_type : String?
        property primary : Bool?
      end
    end
  end
end
