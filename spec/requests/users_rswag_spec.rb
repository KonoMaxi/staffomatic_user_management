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
              archived_eq: { type: :boolean }
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
          let (:filter) { { filter: { archived_eq: true } } }
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data.dig("data").length).to eq(1)
          end
        end

        describe 'allows filtering only unarchived users' do
          let (:filter) { { filter: { archived_eq: false } } }
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
        let (:filter) { {} }

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
                id: { type: :string }
              }
            }
          }
        let ('Authentication') { 'Bearer ' + generate_token(users(:one)) }
        let ('id') { users(:two).id }

        before do |example|
          expect(Audited::Audit.count).to equal(0)
          submit_request(example.metadata)
        end
      
        it 'destroys the user with audit' do |example|
          assert_response_matches_metadata(example.metadata)
          expect(Audited::Audit.count).to equal(1)
        end
      end

      response(401, 'Unauthorized') do
        schema '$ref' => '#/components/schemas/login_prompt'
        let ('Authentication') { 'Bearer super_invalid_token' }
        let ('id') { users(:one).id }

        run_test!
      end

      response(403, 'Forbidden Self-Deletion') do
        schema '$ref' => '#/components/schemas/jsonapi_error'
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
        let ('id') { -1 }

        run_test!
      end
    end
  end

  path '/users/{id}/archive' do
    patch('update users archive-status') do
      parameter name: :id, in: :path, type: :string
      parameter name: :status, in: :body, schema: {
        type: :object,
        properties: {
          id: { type: :string },
          type: { type: :string },
          data: {
            type: :object,
            properties: {
              attributes: {
                type: :object,
                properties: {
                  archived: { type: :boolean }
                }
              }
            }
          }
        }
      }
      consumes 'application/vnd.api+json'
      produces 'application/vnd.api+json'
      security [Bearer: []]
      
      response(200, 'successful') do
        schema type: :object,
          data: { '$ref' => '#/components/schemas/user' }
        let ('Authentication') { 'Bearer ' + generate_token(users(:two)) }
        let ('id') { users(:one).id }
        let ('status') { {
          id: users(:one).id,
          type: "user",
          data: {
            attributes: {
              archived: true
            }
          }
        } }
  
        before do |example|
          expect(users(:one).audits.count).to equal(0)
          submit_request(example.metadata)
        end
      
        it 'archives the user with audit' do |example|
          assert_response_matches_metadata(example.metadata)
          expect(users(:one).audits.count).to equal(1)
        end
      end
   
      response(401, 'Unauthorized') do
        schema '$ref' => '#/components/schemas/login_prompt'
        let ('Authentication') { 'Bearer super_invalid_token' }
        let ('id') { users(:one).id }
        let ('status') { { data: { archived: true }} }
  
        run_test!
      end

      response(403, 'Forbidden Self-Archiving') do
        schema '$ref' => '#/components/schemas/jsonapi_error'
        let ('Authentication') { 'Bearer ' + generate_token(users(:one)) }
        let ('id') { users(:one).id }
        let ('status') { { data: { archived: true }} }

        run_test!
      end

      response(404, 'User Not Found') do
        schema '$ref' => '#/components/schemas/jsonapi_error'
        let ('Authentication') { 'Bearer ' + generate_token(users(:one)) }
        let ('id') { -1 }
        let ('status') { { data: { archived: true }} }
        run_test!
      end

      response(422, 'Already archived') do
        schema '$ref' => '#/components/schemas/jsonapi_error'
        let ('Authentication') { 'Bearer ' + generate_token(users(:one)) }
        let ('id') { users(:three).id }
        let ('status') { { data: { archived: true }} }

        run_test!
      end
    end
  end
end
