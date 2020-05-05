module Google
  class Directory
    class User
      class Phone
        include JSON::Serializable

        property value : String
        property primary : Bool?
        property type : String

        @[JSON::Field(key: "customType")]
        property custom_type : String?
      end
    end
  end
end
