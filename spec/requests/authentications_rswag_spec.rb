require 'swagger_helper'

RSpec.describe 'authentications', type: :request do
  fixtures :users
  path '/authentications' do
    post('create authentication') do
      produces 'application/json'
      parameter name: :credentials, in: :query, schema: {
        type: :object,
        properties: {
          authentication: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string }
            },
            required: [ 'email', 'password' ]
          }
        },
        required: [ 'authentication' ]
      }

      response(201, 'created') do
        schema type: :object,
          properties: {
            user_id: { type: :integer },
            user_email: { type: :string },
            token: { type: :string }
          },
          required: [ 'user_id', 'user_email', 'token' ]

        let(:credentials) {{
          authentication: {
            email: users(:one).email, password: password_one
          }
        }}
        run_test!
      end

      response('422', 'invalid request') do
        schema type: :object,
          properties: {
            error: { type: :string }
          },
          required: [ 'error' ]

        let(:credentials) {{
          authentication: {
            email: users(:one).email, password: 'incorrect_password'
          }
        }}
        run_test!
      end
    end
  end
end
