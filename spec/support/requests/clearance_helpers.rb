module Requests
  module ClearanceHelpers
    def sign_in_request(email, password)
      post session_url, params: {
        session: { email: email, password: password }
      }
    end

    def remember_token_regex(token)
      Regexp.new("remember_token=#{token};")
    end

    def expect_response_sets_remember_token_cookie(token)
      regexp = remember_token_regex token
      expect(response.headers['set-cookie']).to include(regexp)
    end
  end
end
