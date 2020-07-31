module Google
  class EventTicketObject
    include JSON::Serializable

    property id : String

    @[JSON::Field(key: "classId")]
    property class_id : String

    property state : String = "active"

    property barcode : Barcode

    @[JSON::Field(key: "ticketHolderName")]
    property ticket_holder_name : String

    def initialize(@id, @class_id, @ticket_holder_name, qr_code_value : String, qr_code_alternate_text : String? = nil)
      @barcode = Barcode.new(qr_code_value, qr_code_alternate_text)
    end

    struct Barcode
      include JSON::Serializable

      @[JSON::Field(key: "value")]
      property qr_code_value : String

      @[JSON::Field(key: "alternateText")]
      property qr_code_alternate_text : String?

      @[JSON::Field(key: "type")]
      property barcode_type : String = "QR_CODE"

      def initialize(@qr_code_value, @qr_code_alternate_text)
      end
    end
  end
end
