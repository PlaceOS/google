require "../../spec_helper"
require "../../../src/passes/models/event_ticket_object"

describe Google::EventTicketObject do
  it "json with minimal params, works!" do
    object = Google::EventTicketObject.new("123", "234", "John Smith", qr_code_value: "112234")
    object.to_json.should eq("{\"id\":\"123\",\"classId\":\"234\",\"state\":\"active\",\"barcode\":{\"value\":\"112234\",\"type\":\"QR_CODE\"},\"ticketHolderName\":\"John Smith\"}")
  end

  it "json with all params, works!" do
    object = Google::EventTicketObject.new("123", "234", "John Smith", qr_code_value: "112234", qr_code_alternate_text: "John's custom text")
    object.to_json.should eq("{\"id\":\"123\",\"classId\":\"234\",\"state\":\"active\",\"barcode\":{\"value\":\"112234\",\"alternateText\":\"John's custom text\",\"type\":\"QR_CODE\"},\"ticketHolderName\":\"John Smith\"}")
  end
end
