class UserChangedWebhookJob < ApplicationJob
  queue_as :default

  def perform
    HTTParty.post('http://www.example.com', body: { message: "you were changed!" })
  end
end
