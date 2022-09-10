require 'rails_helper'

RSpec.describe 'Users', type: :request do
  fixtures :users

  describe 'GET /index' do
    it 'returns http success' do
      auth_token = authenticate_user(users(:one), password_one)
      get users_path, headers: { 'Authentication' => "Bearer #{auth_token}" }
      expect(response).to have_http_status(:success)
    end
  end
end
