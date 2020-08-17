module Google
  class Directory
    class User
      class Organization
        include JSON::Serializable

        property name : String?
        property title : String?
        property primary : Bool?
        property type : String?

        @[JSON::Field(key: "customType")]
        property custom_type : String?
        property department : String?
        property symbol : String?
        property location : String?
        property description : String?
        property domain : String?

        @[JSON::Field(key: "costCenter")]
        property cost_center : String?

        @[JSON::Field(key: "fullTimeEquivalent")]
        property full_time_equivalent : Int32?
      end
    end
  end
end
