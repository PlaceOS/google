module Google
  class Directory
    class User
      class Relation
        include JSON::Serializable

        property value : String
        property type : String

        @[JSON::Field(key: "customType")]
        property custom_type : String?
      end
    end
  end
end
