module Google
  class Directory
    class User
      class Organization
        include JSON::Serializable

        property name : String?
        property title : String
        property primary : Bool?
        property type : String?
        property customType : String?
        property department : String?
        property symbol : String?
        property location : String?
        property description : String?
        property domain : String?
        property costCenter : String?
        property fullTimeEquivalent : Int32?
      end
    end
  end
end
