module Google
  class Directory
    class User
      class Name
        include JSON::Serializable

        property givenName : String
        property familyName : String
        property fullName : String?
      end
    end
  end
end
