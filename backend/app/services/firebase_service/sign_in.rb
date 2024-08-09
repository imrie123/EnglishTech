require 'rest-client'

module FirebaseService
  class SignIn
    def initialize(email, password)
      @user_email = email
      @user_password = password
    end

    def call
      begin
        response = RestClient.post "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=#{ENV['FIREBASE_API_KEY']}",
                                   { email: @user_email, password: @user_password, returnSecureToken: true }.to_json,
                                   { content_type: :json }
        JSON.parse(response)
      rescue RestClient::ExceptionWithResponse => e
        # Return the error response in case of an exception
        e.response
      end
    end

    private

    attr_reader :user_email, :user_password
  end
end