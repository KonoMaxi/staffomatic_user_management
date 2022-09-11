require 'swagger_helper'

RSpec.describe 'users', type: :request do
  fixtures :users

  path '/users' do
    get('list users') do
      produces 'application/json'
      security [Bearer: []]
      
      response(200, 'successful') do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                '$ref' => '#/components/schemas/user'
              }
            }  
          }
        let ('Authentication') { 'Bearer ' + generate_token(users(:one)) }
        run_test!
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/login_prompt'

        run_test!
      end
    end
  end
end
