require "mime/multipart"
require "./calendar"

module Google
  class Calendar
    def batch(requests : Indexable(HTTP::Request), boundary = MIME::Multipart.generate_boundary) : Hash(HTTP::Request, HTTP::Client::Response)
      raise ArgumentError.new("maximum of 750 requests per batch request") if requests.size > 750

      responses = {} of HTTP::Request => HTTP::Client::Response

      # Maximum of 50 requests per-batch
      requests.each_slice(50, reuse: true) do |requests_slice|
        request_uri = "/batch/calendar/v3"

        body = MIME::Multipart.build(boundary) do |builder|
          requests_slice.each_with_index do |request, id|
            builder.body_part(HTTP::Headers{
              "Content-Type" => "application/http",
              "Content-ID"   => "<#{id}@place.tech>",
            }) { |io| request.to_io(io) }
          end
        end

        batch_response = ConnectProxy::HTTPClient.new(GOOGLE_URI) do |client|
          client.exec(
            "POST",
            request_uri,
            HTTP::Headers{
              "Authorization" => "Bearer #{get_token}",
              "User-Agent"    => @user_agent,
              "Content-Type"  => "multipart/mixed; boundary=#{boundary}",
            },
            body
          )
        end

        Google::Exception.raise_on_failure(batch_response)

        if content_type = batch_response.headers["Content-Type"]?
          boundary = MIME::Multipart.parse_boundary(content_type).not_nil!
        end

        MIME::Multipart.parse(batch_response.body_io? || IO::Memory.new(batch_response.body), boundary) do |headers, io|
          # replies to <0@place.tech> with <response-0@place.tech>
          id = headers["Content-ID"].split("@")[0][10..-1].to_i
          response = HTTP::Client::Response.from_io(io)
          responses[requests_slice[id]] = response
        end
      end

      responses
    end
  end
end
