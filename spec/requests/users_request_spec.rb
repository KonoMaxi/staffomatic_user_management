require 'rails_helper'

RSpec.describe "Users", type: :request do

  fixtures :users

  describe "enqueues mails" do
    it 'for destroyed' do
      expect {
        delete user_path(users(:two)), headers: { "Authentication": 'Bearer ' + generate_token(users(:one)) }
      }.to have_enqueued_mail(UserModifiedMailer, :send_notification)
    end

    it 'for updated' do
      expect {
        patch archive_user_path(users(:two)),
          params: {
            id: users(:one).id,
            type: "user",
            data: {
              attributes: {
                archived: true
              }
            }
          }, headers: { "Authentication": 'Bearer ' + generate_token(users(:one)) }
      }.to have_enqueued_mail(UserModifiedMailer, :send_notification)
    end
  end

  describe "enqueues webhook jobs" do
    it 'for destroyed' do
      expect {
        delete user_path(users(:two)), headers: { "Authentication": 'Bearer ' + generate_token(users(:one)) }
      }.to have_enqueued_job(UserChangedWebhookJob)
    end

    it 'for updated' do
      expect {
        patch archive_user_path(users(:two)),
          params: {
            id: users(:one).id,
            type: "user",
            data: {
              attributes: {
                archived: true
              }
            }
          }, headers: { "Authentication": 'Bearer ' + generate_token(users(:one)) }
      }.to have_enqueued_job(UserChangedWebhookJob)

    end
  end
end
