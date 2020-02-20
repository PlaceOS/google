module Google
  class Directory
    class User
      class Phone
        include JSON::Serializable

        property value : String
        property primary : Bool?
        property type : String
        property customType : String?
      end
    end
  end
end
