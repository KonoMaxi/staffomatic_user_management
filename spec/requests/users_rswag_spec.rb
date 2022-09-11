require 'swagger_helper'

RSpec.describe 'users', type: :request do
  fixtures :users

  path '/users' do
    get('list users') do
      parameter name: :filter, in: :query, schema: {
        type: :object,
        properties: {
          filter: {
            type: :object,
            properties: {
              archived: { type: :boolean }
            }
          }
        }
      }
      produces 'application/vnd.api+json'
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
        
        describe 'allows filtering only archived users' do
          let (:filter) { { filter: { archived: true } } }
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data.dig("data").length).to eq(1)
          end
        end

        describe 'allows filtering only unarchived users' do
          let (:filter) { { filter: { archived: false } } }
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data.dig("data").length).to eq(2)
          end
        end

        describe 'without filtering' do
          let (:filter) { {} }
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data.dig("data").length).to eq(3)
          end
        end
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/login_prompt'
        let ('Authentication') { 'Bearer super_invalid_token' }

        run_test!
      end
    end
  end

  path '/users/{id}' do
    delete('destroy user') do
      parameter name: :id, in: :path, type: :integer
      produces 'application/vnd.api+json'
      security [Bearer: []]
      
      response(200, 'successful') do
        schema type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                type: { type: :string, enum: [ 'user' ] },
                id: { type: :integer }
              }
            }
          }
        let ('Authentication') { 'Bearer ' + generate_token(users(:one)) }
        let ('id') { users(:two).id }

        run_test!
      end

      response(401, 'Unauthorized') do
        schema '$ref' => '#/components/schemas/login_prompt'
        let ('Authentication') { 'Bearer super_invalid_token' }
        let ('id') { users(:one).id }

        run_test!
      end

      response(403, 'Forbidden Self-Deletion') do
        schema '$ref' => '#/components/schemas/basic_error'
        let ('Authentication') { 'Bearer ' + generate_token(users(:one)) }
        let ('id') { users(:one).id }

        run_test!
      end

      response(404, 'User Not Found') do
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
    end
  end

  path '/users/{id}/archive' do
    patch('update users archive-status') do
      parameter name: :id, in: :path, type: :integer
      produces 'application/vnd.api+json'
      security [Bearer: []]
      
      response(200, 'successful') do
        schema type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                type: { type: :string, enum: [ 'user' ] },
                id: { type: :integer }
              }
            }  
          }
        let ('Authentication') { 'Bearer ' + generate_token(users(:one)) }
        let ('id') { users(:two).id }
  
        run_test!
      end
   
      response(401, 'Unauthorized') do
        schema '$ref' => '#/components/schemas/login_prompt'
        let ('Authentication') { 'Bearer super_invalid_token' }
        let ('id') { users(:one).id }
        let ('status') { true }
  
        run_test!
      end

      response(403, 'Forbidden Self-Archiving') do
        schema '$ref' => '#/components/schemas/basic_error'
        let ('Authentication') { 'Bearer ' + generate_token(users(:one)) }
        let ('id') { users(:one).id }

        run_test!
      end

      response(404, 'User Not Found') do
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

      response(422, 'Already archived') do
        schema '$ref' => '#/components/schemas/basic_error'
        let ('Authentication') { 'Bearer ' + generate_token(users(:one)) }
        let ('id') { users(:three).id }

        run_test!
      end
    end
  end
end
