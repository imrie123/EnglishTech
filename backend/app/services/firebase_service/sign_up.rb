require 'rest-client'

module FirebaseService
  class SignUp
    def initialize(email, password)
      @user_email = email
      @user_password = password
    end

    def call
      begin
        response = RestClient.post(
          "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=#{ENV['FIREBASE_API_KEY']}",
          { email: @user_email, password: @user_password, returnSecureToken: true }.to_json,
          { content_type: :json, accept: :json }
        )
        JSON.parse(response.body)
      rescue RestClient::ExceptionWithResponse => e
        puts "HTTP Status: #{e.response.code}"
        puts "Response Body: #{e.response.body}"
        JSON.parse(e.response.body) # エラーメッセージの解析
      rescue StandardError => e
        puts "An unexpected error occurred: #{e.message}"
        { "error" => { "message" => e.message } }
      end
    end

    private

    attr_reader :user_email, :user_password
  end
end