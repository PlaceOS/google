require "../spec_helper"
require "../../src/models/event_ticket_class"

describe Google::EventTicketClass do
  it "json with minimal params, works!" do
    ticket_class = Google::EventTicketClass.new("123", "PlaceOS Pass Issuer", event_name: "John' Bday", location: {lat: 123.001, lon: -111.0020})
    ticket_class.to_json.should eq("{\"id\":\"123\",\"issuerName\":\"PlaceOS Pass Issuer\",\"eventName\":{\"defaultValue\":{\"language\":\"en-US\",\"value\":\"John' Bday\"}},\"reviewStatus\":\"underReview\",\"locations\":[{\"kind\":\"walletobjects#latLongPoint\",\"latitude\":123.001,\"longitude\":-111.002}]}"
    )
  end

  it "json with minimal params + event_details, works!" do
    ticket_class = Google::EventTicketClass.new("123", "PlaceOS Pass Issuer", event_name: "John' Bday", location: {lat: 123.001, lon: -111.0020}, event_details: {header: "Event header", body: "Event Body"})
    ticket_class.to_json.should eq("{\"id\":\"123\",\"issuerName\":\"PlaceOS Pass Issuer\",\"eventName\":{\"defaultValue\":{\"language\":\"en-US\",\"value\":\"John' Bday\"}},\"reviewStatus\":\"underReview\",\"locations\":[{\"kind\":\"walletobjects#latLongPoint\",\"latitude\":123.001,\"longitude\":-111.002}],\"textModulesData\":[{\"header\":\"Event header\",\"body\":\"Event Body\"}]}"
    )
  end

  it "json with minimal params + date_time, works!" do
    ticket_class = Google::EventTicketClass.new("123", "PlaceOS Pass Issuer", event_name: "John' Bday", location: {lat: 123.001, lon: -111.0020}, date_time: {start: "2023-04-12T11:20:50.52Z", end: "2023-04-12T16:20:50.52Z"})
    ticket_class.to_json.should eq("{\"id\":\"123\",\"issuerName\":\"PlaceOS Pass Issuer\",\"eventName\":{\"defaultValue\":{\"language\":\"en-US\",\"value\":\"John' Bday\"}},\"reviewStatus\":\"underReview\",\"locations\":[{\"kind\":\"walletobjects#latLongPoint\",\"latitude\":123.001,\"longitude\":-111.002}],\"dateTime\":{\"kind\":\"walletobjects#eventDateTime\",\"start\":\"2023-04-12T11:20:50.52Z\",\"end\":\"2023-04-12T16:20:50.52Z\"}}"
    )
  end

  it "json with minimal params + logo_image, works!" do
    ticket_class = Google::EventTicketClass.new("123", "PlaceOS Pass Issuer", event_name: "John' Bday", location: {lat: 123.001, lon: -111.0020}, logo_image: {uri: "https://farm8.staticflickr.com/7340/11177041185_a61a7f2139_o.jpg", description: "Baconrista stadium logo"})
    ticket_class.to_json.should eq("{\"id\":\"123\",\"issuerName\":\"PlaceOS Pass Issuer\",\"eventName\":{\"defaultValue\":{\"language\":\"en-US\",\"value\":\"John' Bday\"}},\"reviewStatus\":\"underReview\",\"locations\":[{\"kind\":\"walletobjects#latLongPoint\",\"latitude\":123.001,\"longitude\":-111.002}],\"logo\":{\"kind\":\"walletobjects#image\",\"sourceUri\":{\"uri\":\"https://farm8.staticflickr.com/7340/11177041185_a61a7f2139_o.jpg\",\"description\":\"Baconrista stadium logo\"}}}"
    )
  end

  it "json with minimal params + event_image, works!" do
    ticket_class = Google::EventTicketClass.new("123", "PlaceOS Pass Issuer", event_name: "John' Bday", location: {lat: 123.001, lon: -111.0020}, event_image: {uri: "https://farm8.staticflickr.com/7340/11177041185_a61a7f2139_o.jpg", description: "Baconrista stadium logo"})
    ticket_class.to_json.should eq("{\"id\":\"123\",\"issuerName\":\"PlaceOS Pass Issuer\",\"eventName\":{\"defaultValue\":{\"language\":\"en-US\",\"value\":\"John' Bday\"}},\"reviewStatus\":\"underReview\",\"locations\":[{\"kind\":\"walletobjects#latLongPoint\",\"latitude\":123.001,\"longitude\":-111.002}],\"imageModulesData\":[{\"mainImage\":{\"kind\":\"walletobjects#image\",\"sourceUri\":{\"uri\":\"https://farm8.staticflickr.com/7340/11177041185_a61a7f2139_o.jpg\",\"description\":\"Baconrista stadium logo\"}}}]}"
    )
  end

  it "json with minimal params + venue, works!" do
    ticket_class = Google::EventTicketClass.new("123", "PlaceOS Pass Issuer", event_name: "John' Bday", location: {lat: 123.001, lon: -111.0020}, venue: {name: "My own venue", address: "123 Street, Bourke St"})
    ticket_class.to_json.should eq("{\"id\":\"123\",\"issuerName\":\"PlaceOS Pass Issuer\",\"eventName\":{\"defaultValue\":{\"language\":\"en-US\",\"value\":\"John' Bday\"}},\"reviewStatus\":\"underReview\",\"locations\":[{\"kind\":\"walletobjects#latLongPoint\",\"latitude\":123.001,\"longitude\":-111.002}],\"venue\":{\"name\":{\"kind\":\"walletobjects#localizedString\",\"defaultValue\":{\"kind\":\"walletobjects#translatedString\",\"language\":\"en-US\",\"value\":\"My own venue\"}},\"address\":{\"kind\":\"walletobjects#localizedString\",\"defaultValue\":{\"kind\":\"walletobjects#translatedString\",\"language\":\"en-US\",\"value\":\"123 Street, Bourke St\"}}}}"
    )
  end
end
