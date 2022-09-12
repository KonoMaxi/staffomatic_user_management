require "rails_helper"

RSpec.describe UserModifiedMailer, type: :mailer do
  fixtures(:users)

  describe("deleted user mail") do
    before(:each) do
      @user = users(:one)
      @user.destroy
      @audit = Audited::Audit.last
    end

    let(:mail) { UserModifiedMailer.send_notification(@user.email, @audit.id) }

    it "renders the headers" do
      expect(mail.subject).to eq("Your account was modified")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("deleted")
    end
  end

  describe "archived user mail" do
    before(:each) do
      @user = users(:one)
      @user.update(archived: true)
      @audit = Audited::Audit.last
    end

    let(:mail) { UserModifiedMailer.send_notification(@user.email, @audit.id) }

    it "renders the body" do
      expect(mail.body.encoded).to match(" archived.")
    end
  end

  describe "unarchived user mail" do
    before(:each) do
      @user = users(:three)
      @user.update(archived: false)
      @audit = Audited::Audit.last
    end

    let(:mail) { UserModifiedMailer.send_notification(@user.email, @audit.id) }

    it "renders the body" do
      expect(mail.body.encoded).to match(" unarchived.")
    end
  end

end
