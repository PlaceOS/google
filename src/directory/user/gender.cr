module Google
  class Directory
    class User
      class Gender
        include JSON::Serializable

        property type : String
        property customGender : String?
        property addressMeAs : String?
      end
    end
  end
end
