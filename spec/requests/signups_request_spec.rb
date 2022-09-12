require 'rails_helper'

RSpec.describe "Signups", type: :request do
  fixtures :users

  describe "POST /create" do
    fit "successful request creates a user" do
      user_data = {
        data: {
          attributes: {
            email: 'johnny@example.com',
            password: password_one,
            password_confirmation: password_one
          }
        }
      }
      expect {
        post '/signup', params: user_data.to_json, headers: { "Content-Type": "application/json" }
      }.to change(User, :count).by(1)
      expect(response).to have_http_status(:success)
    end

    fit "unsuccessful request does not create a user" do
      user_data = {
        data: {
          attributes: {
            email: 'johnny@example.com',
            password: password_one,
            password_confirmation: password_two
          }
        }
      }
      expect {
        post '/signup', params: user_data.to_json, headers: { "Content-Type": "application/json" }
      }.to change(User, :count).by(0)
      expect(response).to have_http_status(:unprocessable_entity)
    end

  end
end
