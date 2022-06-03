module Google
  module AuthHelper
    private def get_token : String
      case (auth = @auth)
      in Google::Auth, Google::FileAuth then auth.get_token.access_token
      in String                         then auth
      end
    end
  end
end
