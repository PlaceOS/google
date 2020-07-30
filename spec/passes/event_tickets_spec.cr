require "../spec_helper"
require "../../src/passes/event_tickets"

describe Google::EventTickets do
  it "works!" do
    WebMock.stub(:post, "https://www.googleapis.com/oauth2/v4/token")
      .to_return(body: {access_token: "test_token", expires_in: 3599, token_type: "Bearer"}.to_json)
    WebMock.stub(:post, "https://walletobjects.googleapis.com/walletobjects/v1/eventTicketClass")
      .to_return(body: {"test" => true}.to_json)
    WebMock.stub(:post, "https://walletobjects.googleapis.com/walletobjects/v1/eventTicketObject")
      .to_return(body: {"test" => true}.to_json)

    auth = Google::FileAuth.new(file_path: FileAuthHelper.client_auth_file, scopes: "TEST_GOOGLE_API_SCOPE")

    event_tickets = Google::EventTickets.new(auth: auth, issuer_id: "Example ISSUER ID", issuer_name: "Test Org", event_name: "Test Event", ticket_holder_name: "John Smith", location: {lat: 123.009, lon: -121.00001}, origins: ["http://example.com"], qr_code_value: "11221212")
    event_tickets.execute.includes?("https://pay.google.com/gp/v/save/").should be_true
  end
end

module FileAuthHelper
  extend self

  def client_auth_file
    File.expand_path("./spec/fixtures/client_auth.json")
  end
end
