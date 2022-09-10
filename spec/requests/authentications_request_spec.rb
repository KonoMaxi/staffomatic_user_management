require 'rails_helper'

RSpec.describe "Authentications", type: :request do

  fixtures :users

  describe "POST Authentications#create" do
    it 'create JWT tokens for user' do
      auth_params = { authentication: {
        email: users(:one).email,
        password: password_one
      }}
      post '/authentications', params: auth_params.to_json, headers: { "Content-Type": "application/json" }
      json = JSON.parse(response.body)
      expect(response).to have_http_status(201)
    end

    it 'should return errors for invalid auth params' do
      auth_params = { authentication: {
        email: users(:one).email,
        password: 'incorrect_password'
      }}
      post '/authentications', params: auth_params.to_json, headers: { "Content-Type": "application/json" }
      json = JSON.parse(response.body)
      expect(response).to have_http_status(422)
    end
  end
end
