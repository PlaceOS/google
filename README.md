[![Crystal CI](https://github.com/PlaceOS/google/actions/workflows/ci.yml/badge.svg)](https://github.com/PlaceOS/google/actions/workflows/ci.yml)

# google

Provides ability to interact with google services. Feel free to follow [our guide](https://docs.google.com/document/d/1JqyFG8VStwUH01EyR1mJVbrfJQOedm5tUMQCgyVsWbs/edit?usp=sharing) on how to configure API access.

Currently supports following:

* OAuth Token Generation
  - By providing credentials via argument
  - By providing absolute path to `client_auth.json` file
* Directory API
  - List
  - Single user fetch
* Calendar
  - CalendarList
  - Listing calendar events
  - Single calendar event fetch
  - Create calendar event
  - Delete calendar event
  - Update calendar event
  - Move calendar event
  - Availability
* Drive
  - Listing Files in drive
  - Single file fetch
  - Create file
  - Delete file
* Translate
  - List available languages
  - Detect source language
  - Translate one language to another
* Gmail
  - send an email

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     google:
       github: PlaceOS/google
   ```

2. Run `shards install`

## Usage

```crystal
require "google"
```

### Auth

There are three authentication options

#### Google::Auth

```crystal
Google::Auth.new(issuer: "test@example.com", signing_key: PRIVATE_KEY, scopes: "https://www.googleapis.com/auth/admin.directory.user.readonly", sub: "admin@example.com")
```

#### Google::FileAuth

```crystal
Google::FileAuth.new(file_path = "/absolute_path/client_auth.json", scopes: "https://www.googleapis.com/auth/admin.directory.user.readonly", sub: "admin@example.com")
```

#### Access token

```crystal
"pre-generated-google-access-token"
```

For instance 3-legged OAuth2 where a user token has been provided.
i.e.

* https://developers.google.com/identity/protocols/oauth2/web-server#offline
* https://stackoverflow.com/questions/8942340/get-refresh-token-google-api



### Directory

```crystal
# auth variable below can be instance of Google::Auth or Google::FileAuth
directory = Google::Directory.new(auth: auth, domain: "example.com")

# To fetch all users
directory.users

# Fetch single user
directory.lookup("test@example.com")
```

### Calendar

```crystal
# auth variable below can be instance of Google::Auth or Google::FileAuth
calendar = Google::Calendar.new(auth: auth)

# To fetch calendar list
calendar.calendar_list

# To fetch all calendar events
calendar.events

# To fetch single calendar event by id
calendar.event("event_id")

# To create calendar event
calendar.create(event_start: Time.utc, event_end: Time.utc + 1.hour, attendees: ["test@example.com"], summary: "ACA test event", description: "test description", attachments: [Google::Calendar::Attachment.new("file_id", "file_url in google drive")])

# To update single calendar event by id
calendar.update("event_id", summary: "updated summary")

# To delete single calendar event by id
calendar.delete("event_id")

# To move single calendar event by id
calendar.move(event_id: "event_id", calendar_id: "original_calendar_id", destination_id: "destination_calendar_id")

# To fetch availability (free/busy) for a set of mailboxes
calendar.availability(mailboxes: ["test@example.com", "foo@bar.com"], starts_at: Time.utc, ends_at: Time.utc + 1.hour)
```

### Files

```crystal
# auth variable below can be instance of Google::Auth or Google::FileAuth
drive_files = Google::Files.new(auth: auth)

# To fetch files list
drive_files.files

# To fetch single file by id
drive_files.file("file_id")

# To create file
drive_files.create(name: "test.txt", content_bytes: "Hello world!", content_type: "text/plain")

# To delete single file by id
drive_files.delete("file_id")
```

### Translation

```crystal
# auth variable below can be instance of Google::Auth or Google::FileAuth
translate = Google::Translation.new(auth: auth)

# To fetch available languages
translate.languages

# To fetch available languages as localized values
translate.languages("de") # Where "de" is a language code

# To detect the language of a given string (or strings)
translate.detect_language("Some text to detect")

# To translate a string into a target language (auto detecting the source)
translate.translate("Some text to translate", to: "de")

# To translate a string into a target language (with a manual source)
translate.translate("Some text to translate", to: "de", from: "en")
```

### Pay Passes

Currently only allows `TicketClass` and `TicketObject` creation

Output is google pay pass url that can be emailed or shared so that user can save in their google pay app

```crystal
# Current use case is to create meetings as TicketClass and an attendee pass as TicketObject
# `execute` does this in one swoop and creates TicketClass/TicketObject remotely using google api
# jwt payload is then encoded/signed and shared as url

# file_auth variable below is an instance of Google::FileAuth

Google::EventTickets.new(auth: file_auth,
  issuer_id: "YOUR ISSUER ID",
  serial_number: "Unique identifier for the ticket",
  issuer_name: "ISSUER NAME",
  event_name: "TEST EVENT",
  ticket_holder_name: "John Smith",
  location: {"lat": 37.424299996, "lon": -122.0925956000001},
  event_details: {header: "some header", body: "Some other body"},
  date_time: {start: "2023-04-12T11:20:50.52Z", end: "2023-04-12T16:20:50.52Z"},
  logo_image: {uri: "https://farm8.staticflickr.com/7340/11177041185_a61a7f2139_o.jpg", description: "Baconrista stadium logo"},
  event_image: {uri: "http://farm4.staticflickr.com/3738/12440799783_3dc3c20606_b.jpg", description: "Coffee beans"},
  venue: {name: "JK Stadium", address: "123 FYI Str"},
  origins: ["http://baconrista.com", "https://baconrista.com"],
  qr_code_value: "Data encoded in qr_code",
  qr_code_alternate_text: "User Friendly alternate text"
).execute

# Result
"https://pay.google.com/gp/v/u/0/save/ENCODED_SIGNED_JWT_PAYLOAD"

```

## Gmail

Currently using RAW RFC 2822 to send emails, versus the optional custom message JSON.
To generate the message you can use the [email](https://github.com/arcage/crystal-email) shard

```crystal

# auth needs a scope like https://www.googleapis.com/auth/gmail.send
messages = Google::Gmail::Messages.new(auth: auth)

user_id = "steve@place.os"

email = EMail::Message.new
email.from user_id
email.to "to@example.com"
email.subject "subject"
email.message "hello gmail"

messages.send(user_id, email.to_s)
# returns an unparsed response body text currently

```


## Development

To run specs `crystal spec`

## Contributing

1. Fork it (<https://github.com/PlaceOS/google/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
