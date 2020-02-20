module Google
  class Directory
    class User
      class Address
        include JSON::Serializable

        property type : String
        property customType : String?
        property sourceIsStructured : Bool?
        property formatted : String?
        property poBox : String?
        property extendedAddress : String?
        property streetAddress : String?
        property locality : String
        property region : String?
        property postalCode : String?
        property country : String?
        property primary : Bool?
        property countryCode : String?
      end
    end
  end
end
