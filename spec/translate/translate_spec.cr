require "../spec_helper"

describe Google::Translate do
  describe "#languages" do
    it "works in case of successful api call" do
      TranslateHelper.mock_token
      TranslateHelper.mock_languages_call

      languages = TranslateHelper.translate.languages
      languages["af"].should eq("Afrikaans")
    end
  end

  describe "#detect_language" do
    it "works in case of successful api call" do
      TranslateHelper.mock_token
      TranslateHelper.mock_detect_language_call

      detections = TranslateHelper.translate.detect_language("Donde esta el baño?")
      detection = detections.first.first
      detection.language.should eq("es")
      detection.reliable?.should eq(false)
      detection.confidence.should eq(1)
    end
  end

  describe "#translate" do
    it "works in case of successful api call" do
      TranslateHelper.mock_token
      TranslateHelper.mock_translate_call

      translations = TranslateHelper.translate.translate("Donde esta el baño?", to: "en")
      translations.first.translated_text.should eq("Where is the bathroom?")
    end
  end
end

module TranslateHelper
  extend self

  def mock_token
    WebMock.stub(:post, "https://www.googleapis.com/oauth2/v4/token")
      .to_return(body: {access_token: "test_token", expires_in: 3599, token_type: "Bearer"}.to_json)
  end

  def mock_languages_call
    WebMock.stub(:get, "https://translate.googleapis.com/language/translate/v2/languages?target=en")
      .to_return(body: {
        data: {
          languages: [
            {
              language: "af",
              name:     "Afrikaans",
            },
            {
              language: "sq",
              name:     "Albanian",
            },
          ],
        },
      }.to_json)
  end

  def mock_detect_language_call
    WebMock.stub(:post, "https://translate.googleapis.com/language/translate/v2/detect")
      .with(body: {q: "Donde esta el baño?"}.to_json)
      .to_return(body: {
        data: {
          detections: [
            [
              {
                language:   "es",
                isReliable: false,
                confidence: 1,
              },
            ],
          ],
        },
      }.to_json)
  end

  def mock_translate_call
    WebMock.stub(:post, "https://translate.googleapis.com/language/translate/v2")
      .with(body: {q: "Donde esta el baño?", target: "en", format: "text", model: "nmt"}.to_json)
      .to_return(body: {
        data: {
          translations: [
            {
              translatedText:         "Where is the bathroom?",
              detectedSourceLanguage: "es",
              model:                  "nmt",
            },
          ],
        },
      }.to_json)
  end

  def translate
    Google::Translate.new(auth)
  end

  def auth
    Google::FileAuth.new(file_path: client_auth_file, scopes: "TEST_GOOGLE_API_SCOPE")
  end

  def client_auth_file
    File.expand_path("./spec/fixtures/client_auth.json")
  end
end
