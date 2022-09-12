require 'rails_helper'

RSpec.describe UserChangedWebhookJob, type: :job do
  include ActiveJob::TestHelper

  fixtures :users

  let(:stub_post) { stub_request(:post, "http://www.example.com") }

  it "requests a webhook" do
    expect {
      UserChangedWebhookJob.perform_later
    }.to have_enqueued_job

    assert_not_requested(stub_post)
    perform_enqueued_jobs
    assert_requested(stub_post)
  end
end
