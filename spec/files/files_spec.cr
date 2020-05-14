require "../spec_helper"

describe Google::Files do
  describe "#files" do
    it "works in case of successful api call" do
      FilesHelper.mock_token
      FilesHelper.mock_files

      files = FilesHelper.files.files
      files.files.first.name.should eq("test.txt")
    end
  end

  describe "#file" do
    it "works in case of successful api call" do
      FilesHelper.mock_token
      FilesHelper.mock_file

      file = FilesHelper.files.file("123")
      file.name.should eq("test.txt")
    end
  end

  describe "#create" do
    it "works in case of successful api call" do
      FilesHelper.mock_token
      FilesHelper.mock_create

      file = FilesHelper.files.create(name: "test.txt", content_bytes: "Hello world!", content_type: "text/plain")
      file.name.should eq("test.txt")
    end
  end

  describe "#delete" do
    it "works in case of successful api call" do
      FilesHelper.mock_token
      FilesHelper.mock_delete

      result = FilesHelper.files.delete("123")
      result.should eq(true)
    end
  end
end

module FilesHelper
  extend self

  def mock_token
    WebMock.stub(:post, "https://www.googleapis.com/oauth2/v4/token")
      .to_return(body: {access_token: "test_token", expires_in: 3599, token_type: "Bearer"}.to_json)
  end

  def file_response
    {
      "id"   => "123",
      "name" => "test.txt",

      "webViewLink" => "https://docs.google.com/spreadsheets/d/123/edit?usp=drivesdk",
    }
  end

  def files_response
    {
      "files" => [file_response],
    }
  end

  def mock_files
    WebMock.stub(:get, "https://www.googleapis.com/drive/v3/files?fields=*")
      .to_return(body: files_response.to_json)
  end

  def mock_file
    WebMock.stub(:get, "https://www.googleapis.com/drive/v3/files/123?fields=*")
      .to_return(body: file_response.to_json)
  end

  def mock_create
    WebMock.stub(:post, "https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart")
      .to_return(body: file_response.to_json)
  end

  def mock_delete
    WebMock.stub(:delete, "https://www.googleapis.com/drive/v3/files/123")
      .to_return(body: "")
  end

  def files
    Google::Files.new(auth: auth)
  end

  def auth
    Google::FileAuth.new(file_path: client_auth_file, scopes: "TEST_GOOGLE_API_SCOPE")
  end

  def client_auth_file
    File.expand_path("./spec/fixtures/client_auth.json")
  end
end
