module Google
  class Translate
    class TranslationResult
      include JSON::Serializable

      @[JSON::Field(key: "translatedText")]
      property translated_text : String

      @[JSON::Field(key: "detectedSourceLanguage")]
      property detected_source_language : String

      property model : String
    end
  end
end
