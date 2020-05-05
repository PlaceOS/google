module Google
  class Directory
    class User
      class Gender
        include JSON::Serializable

        property type : String

        @[JSON::Field(key: "customGender")]
        property custom_gender : String?

        @[JSON::Field(key: "addressMeAs")]
        property address_me_as : String?
      end
    end
  end
end
