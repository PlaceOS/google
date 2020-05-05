module Google
  class Directory
    class User
      class Language
        include JSON::Serializable

        @[JSON::Field(key: "languageCode")]
        property language_code : String

        @[JSON::Field(key: "customLanguage")]
        property custom_language : String?
      end
    end
  end
end
