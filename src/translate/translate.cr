require "connect-proxy"
require "json"
require "uri"

require "../auth/auth"
require "../auth/file_auth"

require "./detection_result"
require "./translation_result"

module Google
  class Translate
    @user_agent : String

    TRANSLATE_URI = URI.parse("https://translate.googleapis.com")

    def initialize(@auth : Google::Auth | Google::FileAuth, user_agent : String? = nil)
      @user_agent = user_agent || @auth.user_agent
    end

    def detect_language(text : String | Array(String))
      response = ConnectProxy::HTTPClient.new(TRANSLATE_URI) do |client|
        client.exec("POST", "/language/translate/v2/detect", HTTP::Headers{
          "Authorization" => "Bearer #{get_token}",
          "User-Agent"    => @user_agent,
        }, body: {"q" => text}.to_json)
      end

      json = JSON.parse(response.body)
      Array(Array(DetectionResult)).from_json(json["data"]["detections"].to_json)
    end

    def translate(text : String | Array(String), to target : String, from source : String? = nil, format : String = "text", model : String = "nmt")
      options = {"q" => text, "target" => target, "source" => source, "format" => format, "model" => model}
      response = ConnectProxy::HTTPClient.new(TRANSLATE_URI) do |client|
        client.exec("POST", "/language/translate/v2", HTTP::Headers{
          "Authorization" => "Bearer #{get_token}",
          "User-Agent"    => @user_agent,
        }, body: options.compact.to_json)
      end

      json = JSON.parse(response.body)
      Array(TranslationResult).from_json(json["data"]["translations"].to_json)
    end

    def languages(target : String = "en", model : String? = nil)
      options = {"target" => target, "model" => model}
      params = options.compact.map { |k, v| "#{k}=#{v}" }.join("&")
      response = ConnectProxy::HTTPClient.new(TRANSLATE_URI) do |client|
        client.exec("GET", "/language/translate/v2/languages?#{params}", HTTP::Headers{
          "Authorization" => "Bearer #{get_token}",
          "User-Agent"    => @user_agent,
        })
      end

      json = JSON.parse(response.body)
      json["data"]["languages"].as_a.map do |item|
        { item["language"].as_s, item["name"].as_s }
      end.to_h
    end

    private def get_token
      @auth.get_token.access_token
    end
  end
end
