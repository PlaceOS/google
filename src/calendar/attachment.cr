module Google
  class Calendar
    class Attachment
      include JSON::Serializable

      @[JSON::Field(key: "fileId")]
      property file_id : String?

      @[JSON::Field(key: "fileUrl")]
      property file_url : String?

      def initialize(@file_id, @file_url)
      end
    end
  end
end
