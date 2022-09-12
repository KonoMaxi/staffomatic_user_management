module RequestSpecHelper
  def authenticate_user(user, password)
    auth_params = { authentication: {
      email: user.email,
      password: password
    }}
    post '/authentications', params: auth_params.to_json, headers: { "Content-Type": "application/json" }
    return json['token']
  end

  private 

    def json
      JSON.parse(response.body)
    end
end
