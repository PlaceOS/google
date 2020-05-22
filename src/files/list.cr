require "./drive_file"

module Google
  class Files
    class List
      include JSON::Serializable

      property files : Array(DriveFile)

      def initialize(@files)
      end
    end
  end
end
