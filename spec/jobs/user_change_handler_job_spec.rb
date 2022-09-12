require 'rails_helper'

RSpec.describe UserChangeHandlerJob, type: :job do
  fixtures :users

  describe "performas after user modification" do
    it "after delete" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        users(:one).destroy
      }.to have_enqueued_job
    end
    it "after archive" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        users(:two).update(archived: true)
      }.to have_enqueued_job
    end
    it "after unarchive" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        users(:three).update(archived: false)
      }.to have_enqueued_job
    end
  end
end
