require 'swagger_helper'

RSpec.describe 'signups', type: :request do

  path '/signup' do

    post('create signup') do
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user_data, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :integer },
              type: { type: :string, enum: [ 'user' ] },
              attributes: {
                type: :object,
                properties: {
                  email: { type: :string },
                  password: { type: :string },
                  password_confirmation: { type: :string }
                },
                required: [ "email", "password", "password_confirmation" ]
              }
            },
            required: [ "attributes" ]
          }
        }
      }
      response(201, 'created') do
        schema '$ref' => '#/components/schemas/user'

        let(:user_data) { {
          data: {
            attributes: {
              email: 'johnny@example.com',
              password: password_one,
              password_confirmation: password_one
            }
          }
        } }

        run_test!
      end

      response(422, 'unprocessable') do
        schema '$ref' => '#/components/schemas/jsonapi_error'

        let(:user_data) { {
          data: {
            type: "user",
            attributes: {
              email: 'johnny@example.com',
              password: password_one,
              password_confirmation: password_two
            }
          }
        } }
        run_test!
      end
    end
  end
end