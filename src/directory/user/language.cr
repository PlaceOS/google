module Google
  class Directory
    class User
      class Language
        include JSON::Serializable

        property languageCode : String
        property customLanguage : String?
      end
    end
  end
end
