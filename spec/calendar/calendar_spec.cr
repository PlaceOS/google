require "../spec_helper"

describe Google::Calendar do
  describe "#calendar_list" do
    it "works in case of successful api call" do
      CalendarHelper.mock_token
      CalendarHelper.mock_calendar_list

      cals = CalendarHelper.calendar.calendar_list
      cals.first.summary.should eq("override")
    end
  end

  describe "#events" do
    it "works in case of successful api call" do
      CalendarHelper.mock_token
      CalendarHelper.mock_events

      CalendarHelper.calendar.events(period_start: Time.utc(2016, 2, 15, 10, 20, 30)).is_a?(Google::Calendar::Events).should eq(true)
    end
  end

  describe "#event" do
    it "works in case of successful api call" do
      CalendarHelper.mock_token
      CalendarHelper.mock_event

      CalendarHelper.calendar.event("123456789").is_a?(Google::Calendar::Event).should eq(true)
    end
  end

  describe "#create" do
    it "works in case of successful api call" do
      CalendarHelper.mock_token
      CalendarHelper.mock_event_create

      CalendarHelper.calendar.create(event_start: Time.utc(2016, 2, 15, 10, 20, 30), event_end: Time.utc(2016, 2, 15, 11, 20, 30), attendees: ["test@example.com"], summary: "ACA test event", description: "test description").is_a?(Google::Calendar::Event).should eq(true)
    end
  end

  describe "#update" do
    it "works in case of successful api call" do
      CalendarHelper.mock_token
      CalendarHelper.mock_event_update

      CalendarHelper.calendar.update("123456789", summary: "updated summary").is_a?(Google::Calendar::Event).should eq(true)
    end
  end

  describe "#decline" do
    it "works in case of successful api call" do
      CalendarHelper.mock_token
      CalendarHelper.mock_event
      CalendarHelper.mock_event_update

      CalendarHelper.calendar.decline("123456789").should eq(true)
    end
  end

  describe "#delete" do
    it "works in case of successful api call" do
      CalendarHelper.mock_token
      CalendarHelper.mock_event_delete

      CalendarHelper.calendar.delete("123456789").should eq(true)
    end
  end

  describe "#move" do
    it "works in case of successful api call" do
      CalendarHelper.mock_token
      CalendarHelper.mock_event_move

      CalendarHelper.calendar.move(event_id: "event_id", calendar_id: "original_calendar_id", destination_id: "destination_calendar_id").is_a?(Google::Calendar::Event).should eq(true)
    end
  end

  describe "#availability" do
    it "works in case of successful api call" do
      CalendarHelper.mock_token
      CalendarHelper.mock_availability

      availability_list = CalendarHelper.calendar.availability(mailboxes: ["test@example.com"], starts_at: Time.utc(2016, 2, 15, 10, 20, 30), ends_at: Time.utc(2016, 2, 15, 11, 20, 30))

      availability_list.first.is_a?(Google::Calendar::CalendarAvailability).should eq(true)
    end
  end

  describe "#batch" do
    it "works in case of successful api call" do
      CalendarHelper.mock_token

      WebMock.stub(:post, "https://www.googleapis.com/batch/calendar/v3")
        .with(
          body: "----------------------------c2KH8mGV_l_gxMQ7c8wngsrk\r\nContent-Type: application/http\r\nContent-ID: <0@place.tech>\r\n\r\nGET /calendar/v3/calendars/primary/events?maxResults=2500&singleEvents=true&timeMin=2016-02-15T10:20:30Z HTTP/1.1\r\nAuthorization: Bearer test_token\r\nUser-Agent: Google on Crystal\r\n\r\n\r\n----------------------------c2KH8mGV_l_gxMQ7c8wngsrk\r\nContent-Type: application/http\r\nContent-ID: <1@place.tech>\r\n\r\nGET /calendar/v3/users/me/calendarList?maxResults=250&showHidden=true&showDeleted=false HTTP/1.1\r\nAuthorization: Bearer test_token\r\nUser-Agent: Google on Crystal\r\n\r\n\r\n----------------------------c2KH8mGV_l_gxMQ7c8wngsrk--",
          headers: {
            "Authorization" => "Bearer test_token",
            "User-Agent"    => "Google on Crystal",
            "Content-Type"  => "multipart/mixed; boundary=--------------------------c2KH8mGV_l_gxMQ7c8wngsrk",
          }
        ).to_return(body: "----------------------------c2KH8mGV_l_gxMQ7c8wngsrk\r\nContent-Type: application/http\r\nContent-ID: <response-1@place.tech>\r\n\r\nHTTP/1.1 200 OK\r\nContent-Type application/json\r\n\r\n#{{
                                                                                                                                                                                                                            "kind":          "calendar#calendarList",
                                                                                                                                                                                                                            "etag":          "12121",
                                                                                                                                                                                                                            "nextSyncToken": "TOKEN123",
                                                                                                                                                                                                                            "items":         [{
                                                                                                                                                                                                                              "kind":            "hi",
                                                                                                                                                                                                                              "etag":            "12121",
                                                                                                                                                                                                                              "id":              "123456789",
                                                                                                                                                                                                                              "summary":         "example summary",
                                                                                                                                                                                                                              "summaryOverride": "override",

                                                                                                                                                                                                                              "hidden":   false,
                                                                                                                                                                                                                              "selected": true,
                                                                                                                                                                                                                              "primary":  true,
                                                                                                                                                                                                                              "deleted":  false,
                                                                                                                                                                                                                            }],
                                                                                                                                                                                                                          }.to_json}\r\n----------------------------c2KH8mGV_l_gxMQ7c8wngsrk\r\nContent-Type: application/http\r\nContent-ID: <response-0@place.tech>\r\n\r\nHTTP/1.1 200 OK\r\nContent-Type application/json\r\n\r\n#{CalendarHelper.events_response.to_json}\r\n\r\n----------------------------c2KH8mGV_l_gxMQ7c8wngsrk--")

      calendar = CalendarHelper.calendar
      request1 = calendar.events_request(period_start: Time.utc(2016, 2, 15, 10, 20, 30))
      request2 = calendar.calendar_list_request
      results = calendar.batch({request1, request2}, "--------------------------c2KH8mGV_l_gxMQ7c8wngsrk")

      cals = calendar.calendar_list(results[request2])
      cals.items.first.summary.should eq("override")

      calendar.events(results[request1]).is_a?(Google::Calendar::Events).should eq(true)
    end
  end
end

module CalendarHelper
  extend self

  def mock_token
    WebMock.stub(:post, "https://www.googleapis.com/oauth2/v4/token")
      .to_return(body: {access_token: "test_token", expires_in: 3599, token_type: "Bearer"}.to_json)
  end

  def mock_calendar_list
    WebMock.stub(:get, "https://www.googleapis.com/calendar/v3/users/me/calendarList?maxResults=250&showHidden=true&showDeleted=false")
      .to_return(body: {
        "kind":          "calendar#calendarList",
        "etag":          "12121",
        "nextSyncToken": "TOKEN123",
        "items":         [{
          "kind":            "hi",
          "etag":            "12121",
          "id":              "123456789",
          "summary":         "example summary",
          "summaryOverride": "override",

          "hidden":   false,
          "selected": true,
          "primary":  true,
          "deleted":  false,
        }],
      }.to_json)
  end

  def mock_availability
    WebMock.stub(:post, "https://www.googleapis.com/calendar/v3/freeBusy")
      .to_return(body: {
        "kind":      "calendar#freeBusy",
        "timeMin":   "2020-05-11T04:12:39.000Z",
        "timeMax":   "2020-05-25T04:12:39.000Z",
        "calendars": {"test@example.com": {"busy": [{
          "start": "2020-05-12T00:41:08-04:00",
          "end":   "2020-05-12T01:41:08-04:00",
        }]}},
      }.to_json)
  end

  def mock_events
    WebMock.stub(:get, "https://www.googleapis.com/calendar/v3/calendars/primary/events?maxResults=2500&singleEvents=true&timeMin=2016-02-15T10:20:30Z")
      .to_return(body: events_response.to_json)
  end

  def events_response
    {
      "kind":          "hi",
      "etag":          "12121",
      "summary":       "example summar",
      "updated":       Time.utc,
      "timeZone":      "Local",
      "accessRole":    "User",
      "nextSyncToken": "TOKEN123",
      "items":         [event_response],
    }
  end

  def mock_event
    WebMock.stub(:get, "https://www.googleapis.com/calendar/v3/calendars/primary/events/123456789")
      .to_return(body: event_response.to_json)
  end

  def mock_event_create
    WebMock.stub(:post, "https://www.googleapis.com/calendar/v3/calendars/primary/events?conferenceDataVersion=0&supportsAttachments=true&sendUpdates=all")
      .to_return(body: event_response.to_json)
  end

  def mock_event_update
    WebMock.stub(:patch, "https://www.googleapis.com/calendar/v3/calendars/primary/events/123456789?supportsAttachments=true&conferenceDataVersion=0&sendUpdates=all")
      .to_return(body: event_response.to_json)
  end

  def mock_event_delete
    WebMock.stub(:delete, "https://www.googleapis.com/calendar/v3/calendars/primary/events/123456789?sendUpdates=all&sendNotifications=true")
      .to_return(body: {"kind": "calendar#calendarDelete"}.to_json)
  end

  def mock_event_move
    WebMock.stub(:post, "https://www.googleapis.com/calendar/v3/calendars/original_calendar_id/events/event_id/move?destination=destination_calendar_id&sendUpdates=all")
      .to_return(body: event_response.to_json)
  end

  def event_response
    {
      "kind":     "test",
      "etag":     "12121",
      "id":       "123456789",
      "iCalUID":  "123456789",
      "htmlLink": "https://example.com",
      "updated":  Time.utc,
      "start":    {"dateTime": Time.utc},
      "creator":  {
        "email": "test@example.com",
      },
      "attendees": [{
        "email": "test@example.com",
        "self":  true,
      }],
    }
  end

  def calendar
    Google::Calendar.new(auth: auth)
  end

  def auth
    Google::FileAuth.new(file_path: client_auth_file, scopes: "TEST_GOOGLE_API_SCOPE")
  end

  def client_auth_file
    File.expand_path("./spec/fixtures/client_auth.json")
  end
end
