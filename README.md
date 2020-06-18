[![Build Status](https://travis-ci.com/PlaceOS/google.svg?branch=master)](https://travis-ci.com/PlaceOS/google)

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

### Auth comes in two flavors

#### Google::Auth

```crystal
Google::Auth.new(issuer: "test@example.com", signing_key: PRIVATE_KEY, scopes: "https://www.googleapis.com/auth/admin.directory.user.readonly", sub: "admin@example.com")
```

#### Google::FileAuth

```crystal
Google::FileAuth.new(file_path = "/absolute_path/client_auth.json", scopes: "https://www.googleapis.com/auth/admin.directory.user.readonly", sub: "admin@example.com")
```

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

## Development

To run specs `crystal spec`

## Contributing

1. Fork it (<https://github.com/PlaceOS/google/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
