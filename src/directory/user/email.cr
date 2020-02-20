module Google
  class Directory
    class User
      class Email
        include JSON::Serializable

        property address : String
        property type : String?
        property customType : String?
        property primary : Bool?
      end
    end
  end
end
