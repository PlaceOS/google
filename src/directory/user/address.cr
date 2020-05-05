module Google
  class Directory
    class User
      class Address
        include JSON::Serializable

        property type : String

        @[JSON::Field(key: "customType")]
        property custom_type : String?

        @[JSON::Field(key: "sourceIsStructured")]
        property source_is_structured : Bool?
        property formatted : String?

        @[JSON::Field(key: "poBox")]
        property po_box : String?

        @[JSON::Field(key: "extendedAddress")]
        property extended_address : String?

        @[JSON::Field(key: "streetAddress")]
        property street_address : String?
        property locality : String?
        property region : String?

        @[JSON::Field(key: "postalCode")]
        property postal_code : String?
        property country : String?
        property primary : Bool?

        @[JSON::Field(key: "countryCode")]
        property country_code : String?
      end
    end
  end
end
