module Google
  class Directory
    class User
      class Relation
        include JSON::Serializable

        property value : String
        property type : String
        property customType : String?
      end
    end
  end
end
