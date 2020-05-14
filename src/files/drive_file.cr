require "json"
require "http"
require "file"
require "../calendar/attachment"

module Google
  class Files
    class DriveFile
      include JSON::Serializable

      @[JSON::Field(key: "webViewLink")]
      property link : String?

      property id : String?
      property name : String

      def initialize(@name)
      end

      def body(content_bytes : String, content_type : String)
        io = IO::Memory.new
        io << "--boundary\r\nContent-Type: application/json\r\n\r\n{name: \"#{name}\"}\r\n"
        builder = HTTP::FormData::Builder.new(io, "boundary")

        file = IO::Memory.new(content_bytes)
        builder.file("file",
          file,
          HTTP::FormData::FileMetadata.new(filename: name),
          HTTP::Headers{"Content-Type" => content_type})
        builder.finish
        io.to_s
      end

      def to_attachment
        Google::Calendar::Attachment.new(id, link)
      end
    end
  end
end
